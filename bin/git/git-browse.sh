#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: git browse [remote]

Open the current branch and directory in the configured remote's web interface.
Defaults to the origin remote.
EOF
}

die() {
    printf 'git-browse: %s\n' "$*" >&2
    exit 1
}

parse_remote_url() {
    local url="$1"
    local address

    url="${url%/}"
    url="${url%.git}"

    if [[ "$url" == *://* ]]; then
        address="${url#*://}"
        address="${address#*@}"
        remote_host="${address%%/*}"
        remote_host="${remote_host%%:*}"
        remote_path="${address#*/}"
    elif [[ "$url" == *:* ]]; then
        address="${url#*@}"
        remote_host="${address%%:*}"
        remote_path="${address#*:}"
    else
        die "unsupported remote URL: $1"
    fi

    remote_path="${remote_path#/}"
    [[ -n "$remote_host" && -n "$remote_path" && "$remote_path" != "$address" ]] || \
        die "unsupported remote URL: $1"
}

append_path() {
    local base_url="$1"

    if [[ -n "$relative_path" ]]; then
        printf '%s/%s/%s\n' "$base_url" "$branch" "$relative_path"
    else
        printf '%s/%s\n' "$base_url" "$branch"
    fi
}

open_url() {
    local url="$1"

    case "$(uname -s)" in
        Darwin)
            open "$url"
            ;;
        Linux)
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$url"
            elif command -v gnome-open >/dev/null 2>&1; then
                gnome-open "$url"
            else
                die "no browser opener found; open $url manually"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            cmd.exe /c start "" "$url" >/dev/null 2>&1 || \
                die "could not open $url"
            ;;
        *)
            die "unsupported operating system: $(uname -s)"
            ;;
    esac
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

[[ $# -le 1 ]] || die "expected at most one remote name"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a Git repository"

remote_name="${1:-origin}"
remote_url="$(git remote get-url "$remote_name")" || die "remote '$remote_name' is not configured"
parse_remote_url "$remote_url"

branch="$(git symbolic-ref --quiet --short HEAD || git rev-parse HEAD)"
relative_path="${GIT_PREFIX:-$(git rev-parse --show-prefix)}"
relative_path="${relative_path%/}"
base_url="https://$remote_host/$remote_path"

case "$remote_host" in
    github.com)
        browse_url="$(append_path "$base_url/tree")"
        ;;
    gitlab.com)
        browse_url="$(append_path "$base_url/-/tree")"
        ;;
    bitbucket.org)
        browse_url="$(append_path "$base_url/src")"
        ;;
    dev.azure.com)
        azure_path="/${relative_path:-}"
        browse_url="$base_url?path=$azure_path&version=GB$branch"
        ;;
    ssh.dev.azure.com|vs-ssh.visualstudio.com)
        azure_remote_path="${remote_path#v3/}"
        azure_organization="${azure_remote_path%%/*}"
        azure_remote_path="${azure_remote_path#*/}"
        azure_project="${azure_remote_path%%/*}"
        azure_repository="${azure_remote_path#*/}"
        if [[ "$remote_path" == v3/* && "$azure_remote_path" == */* ]]; then
            azure_path="/${relative_path:-}"
            browse_url="https://dev.azure.com/$azure_organization/$azure_project/_git/$azure_repository?path=$azure_path&version=GB$branch"
        else
            browse_url="$base_url"
        fi
        ;;
    codeberg.org|gitea.com)
        browse_url="$(append_path "$base_url/src/branch")"
        ;;
    git.sr.ht)
        if [[ -n "$relative_path" ]]; then
            browse_url="$base_url/tree/$branch/item/$relative_path"
        else
            browse_url="$base_url/tree/$branch"
        fi
        ;;
    *)
        browse_url="$base_url"
        ;;
esac

printf 'Opening: %s\n' "$browse_url"
open_url "$browse_url"
