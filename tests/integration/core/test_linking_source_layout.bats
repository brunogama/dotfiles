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

@test "legacy shell core source paths are retired" {
    local repository_root
    repository_root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"

    local path
    for path in .zshenv .zshrc .zprofile .zpreztorc starship.toml; do
        [[ ! -e "$repository_root/zsh/$path" ]]
    done
}
