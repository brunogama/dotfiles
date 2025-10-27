#!/usr/bin/env bash
# Git-specific helper functions for bats integration tests

# Create a test git repository
create_test_repo() {
    local repo_name="$1"
    local repo_path="${2:-$TEST_TEMP_DIR/$repo_name}"

    mkdir -p "$repo_path"
    cd "$repo_path" || return 1

    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    git config init.defaultBranch "main"

    echo "$repo_path"
}

# Make a commit in current repository
make_commit() {
    local message="$1"
    local file="${2:-test-file.txt}"

    echo "content-$(date +%s)" > "$file"
    git add "$file"
    git commit -m "$message"
}

# Create and commit a file
create_and_commit_file() {
    local file="$1"
    local content="${2:-test content}"
    local message="${3:-Add $file}"

    echo "$content" > "$file"
    git add "$file"
    git commit -m "$message"
}

# Create a branch
create_branch() {
    local branch_name="$1"
    local base_branch="${2:-main}"

    git checkout -b "$branch_name" "$base_branch"
}

# Switch to branch
switch_branch() {
    local branch_name="$1"
    git checkout "$branch_name"
}

# Assert current branch
assert_on_branch() {
    local expected_branch="$1"
    local actual_branch
    actual_branch="$(git rev-parse --abbrev-ref HEAD)"

    [[ "$actual_branch" == "$expected_branch" ]] || {
        echo "Expected branch: $expected_branch, but on: $actual_branch" >&2
        return 1
    }
}

# Assert repository is clean (no uncommitted changes)
assert_clean_repo() {
    local status
    status="$(git status --porcelain)"

    [[ -z "$status" ]] || {
        echo "Repository has uncommitted changes:" >&2
        echo "$status" >&2
        return 1
    }
}

# Assert repository is dirty (has uncommitted changes)
assert_dirty_repo() {
    local status
    status="$(git status --porcelain)"

    [[ -n "$status" ]] || {
        echo "Repository is clean, expected uncommitted changes" >&2
        return 1
    }
}

# Assert file is tracked by git
assert_tracked_file() {
    local file="$1"

    git ls-files --error-unmatch "$file" > /dev/null 2>&1 || {
        echo "File not tracked by git: $file" >&2
        return 1
    }
}

# Assert file is not tracked by git
assert_untracked_file() {
    local file="$1"

    if git ls-files --error-unmatch "$file" > /dev/null 2>&1; then
        echo "File is tracked by git, expected untracked: $file" >&2
        return 1
    fi
}

# Assert commit exists
assert_commit_exists() {
    local commit_ref="$1"

    git rev-parse --verify "$commit_ref" > /dev/null 2>&1 || {
        echo "Commit does not exist: $commit_ref" >&2
        return 1
    }
}

# Assert branch exists
assert_branch_exists() {
    local branch_name="$1"

    git rev-parse --verify "$branch_name" > /dev/null 2>&1 || {
        echo "Branch does not exist: $branch_name" >&2
        return 1
    }
}

# Assert branch does not exist
assert_branch_not_exists() {
    local branch_name="$1"

    if git rev-parse --verify "$branch_name" > /dev/null 2>&1; then
        echo "Branch exists, expected not to exist: $branch_name" >&2
        return 1
    fi
}

# Get current commit hash
get_current_commit() {
    git rev-parse HEAD
}

# Get commit count
get_commit_count() {
    git rev-list --count HEAD
}

# Assert commit count
assert_commit_count() {
    local expected_count="$1"
    local actual_count
    actual_count="$(get_commit_count)"

    [[ "$actual_count" == "$expected_count" ]] || {
        echo "Expected $expected_count commits, but found $actual_count" >&2
        return 1
    }
}

# Create remote repository
create_remote_repo() {
    local remote_name="${1:-origin}"
    local remote_path="$TEST_TEMP_DIR/remote-repo"

    mkdir -p "$remote_path"
    cd "$remote_path" || return 1
    git init --bare

    echo "$remote_path"
}

# Add remote to current repository
add_remote() {
    local remote_name="${1:-origin}"
    local remote_path="$2"

    git remote add "$remote_name" "$remote_path"
}

# Assert remote exists
assert_remote_exists() {
    local remote_name="${1:-origin}"

    git remote | grep -q "^$remote_name$" || {
        echo "Remote does not exist: $remote_name" >&2
        return 1
    }
}

# Push to remote
push_to_remote() {
    local remote_name="${1:-origin}"
    local branch="${2:-main}"

    git push -u "$remote_name" "$branch"
}

# Pull from remote
pull_from_remote() {
    local remote_name="${1:-origin}"
    local branch="${2:-main}"

    git pull "$remote_name" "$branch"
}

# Assert repository is behind remote
assert_behind_remote() {
    local branch="${1:-main}"
    local remote="${2:-origin}"

    git fetch "$remote"

    local local_commit
    local remote_commit
    local_commit="$(git rev-parse HEAD)"
    remote_commit="$(git rev-parse "$remote/$branch")"

    [[ "$local_commit" != "$remote_commit" ]] || {
        echo "Repository is not behind remote" >&2
        return 1
    }
}

# Assert repository is ahead of remote
assert_ahead_of_remote() {
    local branch="${1:-main}"
    local remote="${2:-origin}"

    git fetch "$remote"

    local ahead
    ahead="$(git rev-list --count "$remote/$branch..HEAD")"

    [[ "$ahead" -gt 0 ]] || {
        echo "Repository is not ahead of remote" >&2
        return 1
    }
}

# Create merge conflict
create_merge_conflict() {
    local file="${1:-conflict-file.txt}"

    # Create file and commit
    echo "original content" > "$file"
    git add "$file"
    git commit -m "Add $file"

    # Create branch and modify file
    git checkout -b conflict-branch
    echo "branch content" > "$file"
    git add "$file"
    git commit -m "Modify $file in branch"

    # Go back and modify differently
    git checkout main
    echo "main content" > "$file"
    git add "$file"
    git commit -m "Modify $file in main"
}

# Assert merge conflict exists
assert_merge_conflict() {
    local status
    status="$(git status --porcelain)"

    echo "$status" | grep -q "^UU" || {
        echo "No merge conflict detected" >&2
        return 1
    }
}

# Clone repository
clone_repo() {
    local source_repo="$1"
    local dest_path="$2"

    git clone "$source_repo" "$dest_path"
}
