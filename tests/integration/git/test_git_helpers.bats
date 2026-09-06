#!/usr/bin/env bats
# Integration tests for git helper utilities

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Create initial commits
    create_test_file "README.md" "# Test repo"
    git add README.md
    git commit -m "Initial commit"

    # Ensure on main branch
    git checkout -b main 2>/dev/null || git checkout main
}

teardown() {
    git_test_teardown
}

# Git-smart-merge Tests

@test "git-smart-merge: shows help with --help" {
    run_git_script "git-smart-merge" --help
    # Should show usage information
}

@test "git-smart-merge: requires branch argument" {
    run_git_script "git-smart-merge"
    assert_failure
}

@test "git-smart-merge: validates branch exists" {
    run_git_script "git-smart-merge" "nonexistent-branch"
    assert_failure
}

@test "git-smart-merge: handles clean fast-forward merge" {
    # Create feature branch
    git checkout -b feature/test
    create_test_file "feature.txt" "new feature"
    git add feature.txt
    git commit -m "Add feature"

    # Back to main
    git checkout main

    run_git_script "git-smart-merge" "feature/test"
    assert_success

    # Should have feature file
    assert_file_exists "feature.txt"
}

@test "git-smart-merge: supports --dry-run" {
    git checkout -b feature/dryrun
    create_test_file "dry.txt" "content"
    git add dry.txt
    git commit -m "Dry run test"

    git checkout main

    run_git_script "git-smart-merge" "feature/dryrun" --dry-run
    assert_success

    # File should NOT exist (dry run)
    assert_file_not_exists "dry.txt"
}

# Git-reword Tests

@test "git-reword: requires Python" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-reword" --help
    # Should show help
}

# Conventional-commit Tests

@test "conventional-commit: shows help with --help" {
    run_git_script "conventional-commit" --help
    # Should show usage
}

@test "conventional-commit: interactive mode" {
    skip "Requires interactive input"
}

# Git-browse Tests

@test "git-browse: opens public forge repository URLs" {
	local browser_dir="$BATS_TEST_TMPDIR/browser"
	local capture_file="$BATS_TEST_TMPDIR/opened-url"
	local browser
	local remote_url
	local expected_url
	local dotfiles_root

	dotfiles_root="$(get_dotfiles_root)"
	mkdir -p "$browser_dir"
	for browser in open xdg-open gnome-open; do
		printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$1" >"$GIT_BROWSE_CAPTURE"' >"$browser_dir/$browser"
		chmod +x "$browser_dir/$browser"
	done

	while IFS='|' read -r remote_url expected_url; do
		git remote remove origin 2>/dev/null || true
		git remote add origin "$remote_url"
		run env "GIT_BROWSE_CAPTURE=$capture_file" "GIT_CONFIG_GLOBAL=$dotfiles_root/home/.gitconfig" \
			"GIT_CONFIG_NOSYSTEM=1" "PATH=$browser_dir:$dotfiles_root/bin/git:$PATH" git browse
		assert_success
		assert_equal "$(<"$capture_file")" "$expected_url"
	done <<'EOF'
git@github.com:owner/repository.git|https://github.com/owner/repository/tree/main
git@gitlab.com:group/repository.git|https://gitlab.com/group/repository/-/tree/main
git@bitbucket.org:workspace/repository.git|https://bitbucket.org/workspace/repository/src/main
https://dev.azure.com/organization/project/_git/repository|https://dev.azure.com/organization/project/_git/repository?path=%2F&version=GBmain
git@ssh.dev.azure.com:v3/organization/project/repository|https://dev.azure.com/organization/project/_git/repository?path=%2F&version=GBmain
git@codeberg.org:owner/repository.git|https://codeberg.org/owner/repository/src/branch/main
git@git.sr.ht:~owner/repository|https://git.sr.ht/~owner/repository/tree/main
EOF

	git remote set-url origin 'git@github.com:owner/repository.git'
	mkdir -p nested/directory
	cd nested/directory
	run env "GIT_BROWSE_CAPTURE=$capture_file" "GIT_CONFIG_GLOBAL=$dotfiles_root/home/.gitconfig" \
		"GIT_CONFIG_NOSYSTEM=1" "PATH=$browser_dir:$dotfiles_root/bin/git:$PATH" git browse
	assert_success
	assert_equal "$(<"$capture_file")" 'https://github.com/owner/repository/tree/main/nested/directory'

	cd "$TEST_REPO_DIR"
	git remote set-url origin 'https://github.com/owner/repository.git?access_token=secret#fragment'
	run env "GIT_BROWSE_CAPTURE=$capture_file" "GIT_CONFIG_GLOBAL=$dotfiles_root/home/.gitconfig" \
		"GIT_CONFIG_NOSYSTEM=1" "PATH=$browser_dir:$dotfiles_root/bin/git:$PATH" git browse
	assert_success
	assert_equal "$(<"$capture_file")" 'https://github.com/owner/repository/tree/main'
	refute_output --partial 'access_token'

	cd "$TEST_REPO_DIR"
	git remote set-url origin 'git@github.com:owner/repository.git'
	git checkout -b 'feature/#browse'
	mkdir -p 'nested/#notes'
	cd 'nested/#notes'
	run env "GIT_BROWSE_CAPTURE=$capture_file" "GIT_CONFIG_GLOBAL=$dotfiles_root/home/.gitconfig" \
		"GIT_CONFIG_NOSYSTEM=1" "PATH=$browser_dir:$dotfiles_root/bin/git:$PATH" git browse
	assert_success
	assert_equal "$(<"$capture_file")" 'https://github.com/owner/repository/tree/feature/%23browse/nested/%23notes'

	git remote set-url origin 'https://dev.azure.com/organization/project/_git/repository'
	run env "GIT_BROWSE_CAPTURE=$capture_file" "GIT_CONFIG_GLOBAL=$dotfiles_root/home/.gitconfig" \
		"GIT_CONFIG_NOSYSTEM=1" "PATH=$browser_dir:$dotfiles_root/bin/git:$PATH" git browse
	assert_success
	assert_equal "$(<"$capture_file")" 'https://dev.azure.com/organization/project/_git/repository?path=%2Fnested%2F%23notes&version=GBfeature%2F%23browse'
}

@test "git-browse: rejects unsupported remote URLs" {
	git remote add origin 'not-a-remote-url'
	local dotfiles_root
	dotfiles_root="$(get_dotfiles_root)"

	run "$dotfiles_root/bin/git/git-browse.sh"
	assert_failure
	assert_output --partial 'git-browse: unsupported remote URL: not-a-remote-url'
}

@test "git-browse: reports when Linux has no browser opener" {
	local command_dir
	local dotfiles_root
	dotfiles_root="$(get_dotfiles_root)"
	command_dir="$BATS_TEST_TMPDIR/commands"
	mkdir -p "$command_dir"
	ln -s "$(command -v bash)" "$command_dir/bash"
	ln -s "$(command -v git)" "$command_dir/git"
	printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" Linux' > "$command_dir/uname"
	chmod +x "$command_dir/uname"
	git remote add origin 'git@github.com:owner/repository.git'

	run env "PATH=$command_dir" "$dotfiles_root/bin/git/git-browse.sh"
	assert_failure
	assert_output --partial 'git-browse: no browser opener found'
}


@test "git-browse: reports when Linux browser opener fails" {
	local command_dir
	local dotfiles_root
	dotfiles_root="$(get_dotfiles_root)"
	command_dir="$BATS_TEST_TMPDIR/commands"
	mkdir -p "$command_dir"
	ln -s "$(command -v bash)" "$command_dir/bash"
	ln -s "$(command -v git)" "$command_dir/git"
	printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" Linux' > "$command_dir/uname"
	printf '%s\n' '#!/usr/bin/env bash' 'exit 66' > "$command_dir/xdg-open"
	chmod +x "$command_dir/uname" "$command_dir/xdg-open"
	git remote add origin 'git@github.com:owner/repository.git'

	run env "PATH=$command_dir" "$dotfiles_root/bin/git/git-browse.sh"

	assert_failure
	assert_output --partial 'git-browse: no browser opener found'
	assert_output --partial 'Please open this URL in your browser: https://github.com/owner/repository/tree/main'
}
# Git-subrm Tests

@test "git-subrm: removes submodule" {
    skip "Requires submodule setup"
}

# Interactive-cherry-pick Tests

@test "interactive-cherry-pick: requires Python" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "interactive-cherry-pick" --help
    # Should show help
}

# Integration Tests

@test "smart-merge: chooses rebase for linear history" {
    skip "Complex integration test"

    # Create feature branch with no conflicts
    # smart-merge should prefer rebase
}

@test "smart-merge: chooses merge for diverged history" {
    skip "Complex integration test"

    # Create diverged branches
    # smart-merge should use merge commit
}

@test "smart-merge: detects conflicts" {
    # Create conflicting changes
    create_test_file "conflict.txt" "original"
    git add conflict.txt
    git commit -m "Add file"

    # Branch and modify
    git checkout -b feature/conflict
    echo "feature change" > conflict.txt
    git add conflict.txt
    git commit -m "Feature change"

    # Main and modify differently
    git checkout main
    echo "main change" > conflict.txt
    git add conflict.txt
    git commit -m "Main change"

    # Merge should detect conflict
    run_git_script "git-smart-merge" "feature/conflict"
    assert_failure
    assert_output --partial "conflict"
}

# Exit Code Tests

@test "git-smart-merge: exits 0 on successful merge" {
    git checkout -b feature/success
    create_test_file "success.txt" "content"
    git add success.txt
    git commit -m "Success test"

    git checkout main

    run_git_script "git-smart-merge" "feature/success"
    assert_equal "$status" 0
}

@test "git-smart-merge: exits non-zero on failure" {
    run_git_script "git-smart-merge" "nonexistent-branch"
    [[ "$status" -ne 0 ]]
}

# Helper Script Tests

@test "git helpers: all scripts are executable" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    # Check all git scripts are executable
    for script in "$dotfiles_root"/bin/git/*; do
        if [[ -f "$script" && ! -x "$script" ]]; then
            echo "Not executable: $script"
            return 1
        fi
    done
}

@test "git helpers: scripts have proper shebangs" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    for script in "$dotfiles_root"/bin/git/*.sh; do
        if [[ -f "$script" ]]; then
            head -n 1 "$script" | grep -q "^#!"
        fi
    done
}
