#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: git browse [remote]

Open the current branch and directory in the configured remote's web interface.
Defaults to the origin remote.
USAGE
}

die() {
    printf 'git-browse: %s\n' "$*" >&2
    exit 1
}

parse_remote_url() {
    local url="$1"
    local address

    url="${url%%\?*}"
    url="${url%%\#*}"
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

url_encode() {
    local value="$1"
    local preserve_slashes="$2"
    local encoded=""
    local character
    local escaped_character
    local index
    local LC_ALL=C

    for ((index = 0; index < ${#value}; index++)); do
        character="${value:index:1}"
        case "$character" in
            [a-zA-Z0-9.~_-])
                encoded+="$character"
                ;;
            /)
                if [[ "$preserve_slashes" == true ]]; then
                    encoded+="$character"
                else
                    encoded+='%2F'
                fi
                ;;
            *)
                printf -v escaped_character '%%%02X' "'$character"
                encoded+="$escaped_character"
                ;;
        esac
    done

    printf '%s\n' "$encoded"
}

append_path() {
    local base_url="$1"
    local encoded_branch
    local encoded_relative_path

    encoded_branch="$(url_encode "$branch" true)"
    if [[ -n "$relative_path" ]]; then
        encoded_relative_path="$(url_encode "$relative_path" true)"
        printf '%s/%s/%s\n' "$base_url" "$encoded_branch" "$encoded_relative_path"
    else
        printf '%s/%s\n' "$base_url" "$encoded_branch"
    fi
}

open_url() {
    local url="$1"

    case "$(uname -s)" in
        Darwin)
            open "$url"
            ;;
        Linux)
            if command -v xdg-open >/dev/null 2>&1 && xdg-open "$url"; then
                return
            fi
            if command -v gnome-open >/dev/null 2>&1 && gnome-open "$url"; then
                return
            fi
            printf 'git-browse: no browser opener found\n' >&2
            printf 'Please open this URL in your browser: %s\n' "$url" >&2
            exit 1
            ;;
        MINGW*|MSYS*|CYGWIN*)
            if ! cmd.exe //c start "" "$url" >/dev/null 2>&1; then
                printf 'git-browse: no browser opener found\n' >&2
                printf 'Please open this URL in your browser: %s\n' "$url" >&2
                exit 1
            fi
            ;;
        *)
            printf 'Unsupported operating system\n' >&2
            printf 'Please open this URL in your browser: %s\n' "$url" >&2
            exit 1
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
        azure_path="$(url_encode "/${relative_path:-}" false)"
        azure_version="GB$(url_encode "$branch" false)"
        browse_url="$base_url?path=$azure_path&version=$azure_version"
        ;;
    ssh.dev.azure.com|vs-ssh.visualstudio.com)
        azure_remote_path="${remote_path#v3/}"
        azure_organization="${azure_remote_path%%/*}"
        azure_remote_path="${azure_remote_path#*/}"
        azure_project="${azure_remote_path%%/*}"
        azure_repository="${azure_remote_path#*/}"
        if [[ "$remote_path" == v3/* && "$azure_remote_path" == */* ]]; then
            azure_path="$(url_encode "/${relative_path:-}" false)"
            azure_version="GB$(url_encode "$branch" false)"
            browse_url="https://dev.azure.com/$azure_organization/$azure_project/_git/$azure_repository?path=$azure_path&version=$azure_version"
        else
            browse_url="$base_url"
        fi
        ;;
    codeberg.org|gitea.com)
        browse_url="$(append_path "$base_url/src/branch")"
        ;;
    git.sr.ht)
        encoded_branch="$(url_encode "$branch" true)"
        if [[ -n "$relative_path" ]]; then
            encoded_relative_path="$(url_encode "$relative_path" true)"
            browse_url="$base_url/tree/$encoded_branch/item/$encoded_relative_path"
        else
            browse_url="$base_url/tree/$encoded_branch"
        fi
        ;;
    *)
        browse_url="$base_url"
        ;;
esac

printf 'Opening: %s\n' "$browse_url"
open_url "$browse_url"
