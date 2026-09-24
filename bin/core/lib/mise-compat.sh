#!/usr/bin/env bash

set -euo pipefail

manager="${1:-}"
[[ -n "$manager" ]] || { echo "mise compatibility manager is required" >&2; exit 2; }
shift
operation="${1:-}"
[[ -n "$operation" ]] || { echo "$manager: an operation is required" >&2; exit 2; }
shift

echo "$manager is deprecated in these dotfiles. Use mise directly to keep runtimes current with security fixes." >&2
command -v mise >/dev/null 2>&1 || { echo "$manager: mise is not installed" >&2; exit 2; }

case "$manager" in
    nvm) tool=node ;;
    pyenv) tool=python ;;
    rbenv) tool=ruby ;;
    sdk)
        case "$operation" in
            install|use|default|current|list|uninstall)
                [[ $# -gt 0 ]] || { echo "sdk $operation requires a candidate" >&2; exit 2; }
                tool="$1"
                shift
                ;;
            *) echo "sdk $operation is not supported; use mise directly" >&2; exit 2 ;;
        esac
        ;;
    *) echo "Unknown compatibility manager: $manager" >&2; exit 2 ;;
esac

version="${1:-}"
case "$version" in
    --lts|lts/\*) version=lts ;;
esac

case "$operation" in
    install)
        if [[ -z "$version" && "$manager" == nvm ]]; then
            exec mise install node
        fi
        [[ -n "$version" ]] || { echo "$manager install requires a version" >&2; exit 2; }
        exec mise install "$tool@$version"
        ;;
    uninstall)
        [[ -n "$version" ]] || { echo "$manager uninstall requires a version" >&2; exit 2; }
        exec mise uninstall "$tool@$version"
        ;;
    global|default)
        if [[ -z "$version" ]]; then
            exec mise current "$tool"
        fi
        exec mise use --global "$tool@$version"
        ;;
    local)
        [[ -n "$version" ]] || { echo "$manager local requires a version" >&2; exit 2; }
        exec mise use --path "$PWD/mise.toml" "$tool@$version"
        ;;
    list|ls|versions)
        [[ "$manager" != sdk ]] || exec mise ls-remote "$tool"
        exec mise ls "$tool"
        ;;
    list-remote|ls-remote|install-list)
        exec mise ls-remote "$tool"
        ;;
    current|version)
        exec mise current "$tool"
        ;;
    which)
        [[ -n "$version" ]] || { echo "$manager which requires a command" >&2; exit 2; }
        exec mise which "$version"
        ;;
    prefix|root)
        exec mise where "$tool"
        ;;
    rehash)
        exec mise reshim
        ;;
    alias)
        if [[ "$manager" == nvm && "$version" == default ]]; then
            [[ $# -ge 2 ]] || exec mise current node
            exec mise use --global "node@$2"
        fi
        echo "nvm alias only supports 'default VERSION'; use mise directly" >&2
        exit 2
        ;;
    exec)
        if [[ "$manager" == nvm ]]; then
            [[ $# -ge 2 ]] || { echo "nvm exec requires a version and command" >&2; exit 2; }
            shift
            exec mise exec "$tool@$version" -- "$@"
        fi
        exec mise exec -- "$@"
        ;;
    use|shell)
        echo "$manager $operation changes the current shell; use the interactive zsh compatibility function or 'mise shell'" >&2
        exit 2
        ;;
    *)
        echo "$manager $operation is not supported; use mise directly" >&2
        exit 2
        ;;
esac
