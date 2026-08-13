#!/usr/bin/env bats

@test "shell core files live in the common home source tree" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in \
        .zshenv \
        .config/zsh/.zshrc \
        .config/zsh/.zprofile \
        .config/zsh/.zpreztorc \
        .config/starship.toml; do
        [[ -f "$repository_root/home/$path" ]]
    done
}

@test "shell support files live in the common home source tree" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in \
        .config/zsh/work-config.zsh \
        .config/zsh/personal-config.zsh \
        .config/zsh/lib/lazy-load.zsh \
        .config/zsh/completion/_pi \
        .config/zsh/completion/git-ignore-completion; do
        [[ -f "$repository_root/home/$path" ]]
    done
}

@test "legacy shell support source paths are retired" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in \
        work-config.zsh \
        personal-config.zsh \
        lib/lazy-load.zsh \
        completion/_pi \
        completion/git-ignore-completion; do
        [[ ! -e "$repository_root/zsh/$path" ]]
    done
}

@test "common Git and tool files live in the common home source tree" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in \
        .gitconfig \
        .gitignore_global \
        .config/git/conventional-commits-gitmessage \
        .config/git/github-flow-aliases.gitconfig \
        .config/mise/config.toml \
        .config/home-sync/config.yml; do
        [[ -f "$repository_root/home/$path" ]]
    done
}

@test "legacy common Git and tool source paths are retired" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in \
        git/.gitconfig \
        git/.gitignore_global \
        git/conventional-commits-gitmessage \
        git/github-flow-aliases.gitconfig \
        packages/mise/config.toml \
        packages/syncservice/config.yml; do
        [[ ! -e "$repository_root/$path" ]]
    done
}

@test "legacy shell core source paths are retired" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in .zshenv .zshrc .zprofile .zpreztorc starship.toml; do
        [[ ! -e "$repository_root/zsh/$path" ]]
    done
}
