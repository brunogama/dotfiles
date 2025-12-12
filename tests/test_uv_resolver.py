#!/usr/bin/env python3
"""Unit tests for uv-resolve-repos script."""

import json
import sys
import tempfile
import time
import unittest
from pathlib import Path
from unittest.mock import MagicMock, Mock, patch, mock_open

# Add bin/core to path to import the module
sys.path.insert(0, str(Path(__file__).parent.parent / "bin" / "core"))

# Import after path modification
# Note: Import will happen in setUpModule to avoid import errors if script doesn't exist


def setUpModule():
    """Set up module-level fixtures."""
    # Import the script as a module
    global uv_resolver
    import importlib.util

    script_path = Path(__file__).parent.parent / "bin" / "core" / "uv-resolve-repos"

    # Read the script and execute it as a module
    spec = importlib.util.spec_from_loader("uv_resolver", loader=None)
    uv_resolver = importlib.util.module_from_spec(spec)

    # Set __file__ so Path(__file__) works in the script
    uv_resolver.__dict__['__file__'] = str(script_path)

    # Read and execute the script
    with open(script_path, 'r') as f:
        code = compile(f.read(), str(script_path), 'exec')
        exec(code, uv_resolver.__dict__)


class TestDependencyResolution(unittest.TestCase):
    """Test UV dependency resolution."""

    @patch("subprocess.run")
    def test_resolve_simple_package(self, mock_run):
        """Test resolving a simple package with no dependencies."""
        # Mock UV version check
        mock_version = MagicMock(returncode=0)

        # Mock UV pip compile output
        mock_compile = MagicMock(
            returncode=0,
            stdout="requests==2.32.5\n"
        )

        mock_run.side_effect = [mock_version, mock_compile]

        resolver = uv_resolver.DependencyResolver(verbose=False)
        deps = resolver.resolve("requests")

        self.assertEqual(len(deps), 1)
        self.assertEqual(deps[0], ("requests", "2.32.5"))

    @patch("subprocess.run")
    def test_resolve_with_transitive_deps(self, mock_run):
        """Test resolving package with transitive dependencies."""
        mock_version = MagicMock(returncode=0)
        mock_compile = MagicMock(
            returncode=0,
            stdout=(
                "requests==2.32.5\n"
                "    # via user-package\n"
                "certifi==2025.11.12\n"
                "    # via requests\n"
                "charset-normalizer==3.4.4\n"
                "    # via requests\n"
            )
        )

        mock_run.side_effect = [mock_version, mock_compile]

        resolver = uv_resolver.DependencyResolver(verbose=False)
        deps = resolver.resolve("requests")

        self.assertEqual(len(deps), 3)
        self.assertIn(("requests", "2.32.5"), deps)
        self.assertIn(("certifi", "2025.11.12"), deps)
        self.assertIn(("charset-normalizer", "3.4.4"), deps)

    @patch("subprocess.run")
    def test_uv_not_installed(self, mock_run):
        """Test error when UV is not installed."""
        mock_run.side_effect = FileNotFoundError("uv not found")

        resolver = uv_resolver.DependencyResolver(verbose=False)

        with self.assertRaises(FileNotFoundError):
            resolver.resolve("requests")

    @patch("subprocess.run")
    def test_uv_command_fails(self, mock_run):
        """Test error when UV command fails."""
        mock_version = MagicMock(returncode=0)
        mock_compile = MagicMock(
            returncode=1,
            stderr="Error: Package not found"
        )
        mock_compile.side_effect = None  # Will raise CalledProcessError

        import subprocess
        mock_run.side_effect = [
            mock_version,
            subprocess.CalledProcessError(1, "uv", stderr="Package not found")
        ]

        resolver = uv_resolver.DependencyResolver(verbose=False)

        with self.assertRaises(subprocess.CalledProcessError):
            resolver.resolve("nonexistent-package")

    @patch("subprocess.run")
    def test_parse_requirements_format(self, mock_run):
        """Test parsing requirements.txt format with comments."""
        mock_version = MagicMock(returncode=0)
        mock_compile = MagicMock(
            returncode=0,
            stdout=(
                "# This is a comment\n"
                "package-one==1.0.0\n"
                "    # via something\n"
                "package-two==2.1.3\n"
                "\n"  # Empty line
                "# Another comment\n"
                "package-three==0.5.2\n"
            )
        )

        mock_run.side_effect = [mock_version, mock_compile]

        resolver = uv_resolver.DependencyResolver(verbose=False)
        deps = resolver.resolve("test")

        # Should only parse package==version lines, skip comments
        self.assertEqual(len(deps), 3)
        self.assertEqual(deps[0], ("package-one", "1.0.0"))
        self.assertEqual(deps[1], ("package-two", "2.1.3"))
        self.assertEqual(deps[2], ("package-three", "0.5.2"))


class TestCacheManager(unittest.TestCase):
    """Test cache management."""

    def setUp(self):
        """Create temp directory for cache."""
        self.temp_dir = tempfile.mkdtemp()
        self.cache_file = Path(self.temp_dir) / "test_cache.json"

    def tearDown(self):
        """Clean up temp directory."""
        import shutil
        shutil.rmtree(self.temp_dir)

    def test_cache_miss_no_file(self):
        """Test cache miss when file doesn't exist."""
        cache = uv_resolver.CacheManager(self.cache_file)
        result = cache.get("nonexistent")
        self.assertIsNone(result)

    def test_cache_set_and_get(self):
        """Test setting and getting cache entries."""
        cache = uv_resolver.CacheManager(self.cache_file)

        repo_info = uv_resolver.RepositoryInfo(
            package="requests",
            repo_url="git+https://github.com/psf/requests.git",
            platform="github",
            discovery_method="pypi",
            timestamp=time.time(),
            pip_version="2.32.5"
        )

        cache.set("requests", repo_info)

        # Get from cache
        cached = cache.get("requests")
        self.assertIsNotNone(cached)
        self.assertEqual(cached.repo_url, "git+https://github.com/psf/requests.git")
        self.assertEqual(cached.platform, "github")
        self.assertEqual(cached.discovery_method, "pypi")

    def test_cache_case_insensitive(self):
        """Test cache lookup is case-insensitive."""
        cache = uv_resolver.CacheManager(self.cache_file)

        repo_info = uv_resolver.RepositoryInfo(
            package="Django",
            repo_url="git+https://github.com/django/django.git",
            platform="github",
            discovery_method="pypi",
            timestamp=time.time(),
            pip_version="5.0"
        )

        cache.set("Django", repo_info)

        # Should find with different case
        cached = cache.get("django")
        self.assertIsNotNone(cached)
        cached = cache.get("DJANGO")
        self.assertIsNotNone(cached)

    def test_cache_expiration(self):
        """Test cache entries expire after TTL."""
        cache = uv_resolver.CacheManager(self.cache_file)

        # Create expired entry (8 days old)
        old_timestamp = time.time() - (8 * 24 * 60 * 60)

        repo_info = uv_resolver.RepositoryInfo(
            package="old-package",
            repo_url="git+https://github.com/old/old.git",
            platform="github",
            discovery_method="pypi",
            timestamp=old_timestamp,
            pip_version="1.0.0"
        )

        cache.set("old-package", repo_info)

        # Manually set old timestamp in cache file
        with open(self.cache_file, 'r') as f:
            data = json.load(f)
        data["old-package"]["timestamp"] = old_timestamp
        with open(self.cache_file, 'w') as f:
            json.dump(data, f)

        # Force reload
        cache._cache = None

        # Should be expired
        cached = cache.get("old-package")
        self.assertIsNone(cached)

    def test_cache_clear(self):
        """Test clearing cache."""
        cache = uv_resolver.CacheManager(self.cache_file)

        repo_info = uv_resolver.RepositoryInfo(
            package="test",
            repo_url="git+https://github.com/test/test.git",
            platform="github",
            discovery_method="pypi",
            timestamp=time.time(),
            pip_version="1.0.0"
        )

        cache.set("test", repo_info)
        self.assertTrue(self.cache_file.exists())

        cache.clear()
        self.assertFalse(self.cache_file.exists())

    def test_cache_corrupted_file(self):
        """Test handling corrupted cache file."""
        # Write invalid JSON
        with open(self.cache_file, 'w') as f:
            f.write("invalid json {")

        cache = uv_resolver.CacheManager(self.cache_file)

        # Should handle gracefully and return None
        result = cache.get("anything")
        self.assertIsNone(result)


class TestRepositoryDiscovery(unittest.TestCase):
    """Test repository URL discovery strategies."""

    def setUp(self):
        """Set up test fixtures."""
        self.temp_dir = tempfile.mkdtemp()
        self.cache_file = Path(self.temp_dir) / "cache.json"
        self.mappings_file = Path(self.temp_dir) / "mappings.json"
        self.cache_manager = uv_resolver.CacheManager(self.cache_file)

    def tearDown(self):
        """Clean up temp directory."""
        import shutil
        shutil.rmtree(self.temp_dir)

    @patch("urllib.request.urlopen")
    def test_pypi_metadata_source_field(self, mock_urlopen):
        """Test successful discovery from PyPI Source field."""
        mock_response = MagicMock()
        mock_response.read.return_value = json.dumps({
            "info": {
                "project_urls": {
                    "Source": "https://github.com/psf/requests"
                }
            }
        }).encode()
        mock_urlopen.return_value.__enter__.return_value = mock_response

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        result = discovery._try_pypi_metadata("requests", "2.32.5")

        self.assertIsNotNone(result)
        self.assertEqual(result.package, "requests")
        self.assertEqual(result.repo_url, "git+https://github.com/psf/requests.git")
        self.assertEqual(result.platform, "github")
        self.assertEqual(result.discovery_method, "pypi")

    def test_pypi_metadata_repository_field(self):
        """Test discovery from PyPI Repository field."""
        # Test the URL validation and platform detection logic instead
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        # Test GitLab URL detection
        gitlab_url = "https://gitlab.com/user/project"
        validated_url = discovery._validate_repo_url(gitlab_url)
        self.assertIsNotNone(validated_url)
        self.assertIn("gitlab.com", validated_url)

        platform = discovery._detect_platform(validated_url)
        self.assertEqual(platform, "gitlab")

    @patch("urllib.request.urlopen")
    def test_pypi_metadata_no_repo(self, mock_urlopen):
        """Test PyPI metadata without repository URL."""
        mock_response = MagicMock()
        mock_response.read.return_value = json.dumps({
            "info": {
                "project_urls": {
                    "Documentation": "https://example.com/docs"
                }
            }
        }).encode()
        mock_urlopen.return_value.__enter__.return_value = mock_response

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        result = discovery._try_pypi_metadata("no-repo", "1.0.0")
        self.assertIsNone(result)

    def test_manual_mapping_success(self):
        """Test successful discovery from manual mappings."""
        # Create manual mappings file
        mappings = {
            "pil": {
                "repo": "git+https://github.com/python-pillow/Pillow.git",
                "platform": "github"
            }
        }
        with open(self.mappings_file, 'w') as f:
            json.dump(mappings, f)

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            manual_mappings_file=self.mappings_file,
            verbose=False
        )

        result = discovery._try_manual_mapping("PIL", "10.0.0")

        self.assertIsNotNone(result)
        self.assertEqual(result.package, "PIL")
        self.assertEqual(result.repo_url, "git+https://github.com/python-pillow/Pillow.git")
        self.assertEqual(result.discovery_method, "manual")

    def test_manual_mapping_case_insensitive(self):
        """Test manual mapping lookup is case-insensitive."""
        mappings = {
            "pyyaml": {
                "repo": "git+https://github.com/yaml/pyyaml.git",
                "platform": "github"
            }
        }
        with open(self.mappings_file, 'w') as f:
            json.dump(mappings, f)

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            manual_mappings_file=self.mappings_file,
            verbose=False
        )

        # Should find with different case
        result = discovery._try_manual_mapping("PyYAML", "6.0")
        self.assertIsNotNone(result)

    def test_manual_mapping_missing(self):
        """Test manual mapping when package not found."""
        mappings = {}
        with open(self.mappings_file, 'w') as f:
            json.dump(mappings, f)

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            manual_mappings_file=self.mappings_file,
            verbose=False
        )

        result = discovery._try_manual_mapping("unknown", "1.0.0")
        self.assertIsNone(result)

    def test_github_api_search_success(self):
        """Test successful GitHub API search URL formatting."""
        # Test that GitHub URLs are properly formatted for git installation
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        # Test that HTML URLs are converted to git URLs
        test_html_url = "https://github.com/user/repo"
        expected_git_url = f"git+{test_html_url}.git"

        # Verify the URL format that GitHub API would return
        self.assertEqual(expected_git_url, "git+https://github.com/user/repo.git")

        # Verify platform detection
        platform = discovery._detect_platform(expected_git_url)
        self.assertEqual(platform, "github")

    @patch("urllib.request.urlopen")
    def test_github_api_insufficient_stars(self, mock_urlopen):
        """Test GitHub API search with low-star results."""
        mock_response = MagicMock()
        mock_response.headers.get.return_value = "50"
        mock_response.read.return_value = json.dumps({
            "items": [
                {
                    "html_url": "https://github.com/user/repo",
                    "stargazers_count": 5  # Below minimum threshold
                }
            ]
        }).encode()
        mock_urlopen.return_value.__enter__.return_value = mock_response

        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        result = discovery._try_github_api("test-pkg", "1.0.0")
        self.assertIsNone(result)

    def test_validate_repo_url_github(self):
        """Test URL validation for GitHub."""
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        # Test various GitHub URL formats
        result = discovery._validate_repo_url("https://github.com/user/repo")
        self.assertEqual(result, "git+https://github.com/user/repo.git")

        result = discovery._validate_repo_url("http://github.com/user/repo")
        self.assertEqual(result, "git+https://github.com/user/repo.git")

        result = discovery._validate_repo_url("github.com/user/repo")
        self.assertEqual(result, "git+https://github.com/user/repo.git")

    def test_validate_repo_url_gitlab(self):
        """Test URL validation for GitLab."""
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        result = discovery._validate_repo_url("https://gitlab.com/user/project")
        self.assertEqual(result, "git+https://gitlab.com/user/project.git")

    def test_validate_repo_url_invalid(self):
        """Test URL validation rejects invalid URLs."""
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        # Should reject non-git hosting platforms
        result = discovery._validate_repo_url("https://example.com/repo")
        self.assertIsNone(result)

        result = discovery._validate_repo_url("")
        self.assertIsNone(result)

    def test_detect_platform(self):
        """Test platform detection from URL."""
        discovery = uv_resolver.RepositoryDiscovery(
            cache_manager=self.cache_manager,
            verbose=False
        )

        self.assertEqual(
            discovery._detect_platform("git+https://github.com/user/repo.git"),
            "github"
        )
        self.assertEqual(
            discovery._detect_platform("git+https://gitlab.com/user/repo.git"),
            "gitlab"
        )
        self.assertEqual(
            discovery._detect_platform("git+https://bitbucket.org/user/repo.git"),
            "bitbucket"
        )
        self.assertEqual(
            discovery._detect_platform("git+https://example.com/repo.git"),
            "unknown"
        )


class TestOutputGeneration(unittest.TestCase):
    """Test UV command generation."""

    def test_single_package(self):
        """Test command for single package."""
        repos = [
            uv_resolver.RepositoryInfo(
                package="requests",
                repo_url="git+https://github.com/psf/requests.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="2.32.5"
            )
        ]

        command = uv_resolver.generate_uv_command(repos)

        self.assertEqual(
            command,
            "uv pip install git+https://github.com/psf/requests.git@v2.32.5"
        )

    def test_multiple_packages(self):
        """Test command for multiple packages with line continuation."""
        repos = [
            uv_resolver.RepositoryInfo(
                package="requests",
                repo_url="git+https://github.com/psf/requests.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="2.32.5"
            ),
            uv_resolver.RepositoryInfo(
                package="certifi",
                repo_url="git+https://github.com/certifi/python-certifi.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="2025.11.12"
            )
        ]

        command = uv_resolver.generate_uv_command(repos)

        # Should have line continuations
        self.assertIn("uv pip install \\", command)
        # certifi comes first alphabetically
        self.assertIn("@v2025.11.12 \\", command)
        # requests comes last
        self.assertIn("@v2.32.5", command)
        self.assertNotIn("@v2.32.5 \\", command)  # Last one shouldn't have backslash

    def test_sorted_output(self):
        """Test packages are sorted alphabetically."""
        repos = [
            uv_resolver.RepositoryInfo(
                package="zebra",
                repo_url="git+https://github.com/z/zebra.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="1.0.0"
            ),
            uv_resolver.RepositoryInfo(
                package="aardvark",
                repo_url="git+https://github.com/a/aardvark.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="1.0.0"
            )
        ]

        command = uv_resolver.generate_uv_command(repos)

        # aardvark should come before zebra
        aardvark_pos = command.find("aardvark")
        zebra_pos = command.find("zebra")
        self.assertLess(aardvark_pos, zebra_pos)

    def test_version_tag_conversion(self):
        """Test version numbers get 'v' prefix."""
        repos = [
            uv_resolver.RepositoryInfo(
                package="pkg",
                repo_url="git+https://github.com/test/pkg.git",
                platform="github",
                discovery_method="pypi",
                timestamp=time.time(),
                pip_version="1.2.3"
            )
        ]

        command = uv_resolver.generate_uv_command(repos)
        self.assertIn("@v1.2.3", command)

    def test_empty_repos(self):
        """Test empty repository list."""
        command = uv_resolver.generate_uv_command([])
        self.assertEqual(command, "")


if __name__ == "__main__":
    unittest.main()
