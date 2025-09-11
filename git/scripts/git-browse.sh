#!/bin/bash

# Exit on error
set -e

# Get the remote URL for origin
remote_url=$(git config --get remote.origin.url)
echo "Original URL: $remote_url"

# Function to convert SSH URL to HTTPS
convert_url() {
    local url="$1"
    # Handle GitHub SSH URLs (git@github.com:user/repo.git)
    if [[ "$url" == *"github.com"* ]]; then
        url=${url#git@github.com:}
        url=${url%.git}
        url="https://github.com/$url"
    # Handle GitLab SSH URLs (git@gitlab.com:user/repo.git)
    elif [[ "$url" == *"gitlab"* ]]; then
        url=${url#git@*:}
        url=${url%.git}
        # Handle both gitlab.com and self-hosted instances
        if [[ "$remote_url" == *"gitlab.com"* ]]; then
            url="https://gitlab.com/$url"
        else
            # Extract domain for self-hosted GitLab
            domain=$(echo "$remote_url" | grep -o '@.*:' | sed 's/@//;s/://')
            url="https://$domain/$url"
        fi
    # Handle Bitbucket SSH URLs (git@bitbucket.org:user/repo.git)
    elif [[ "$url" == *"bitbucket"* ]]; then
        url=${url#git@bitbucket.org:}
        url=${url%.git}
        url="https://bitbucket.org/$url"
    fi
    echo "$url"
}

# Convert SSH URL to HTTPS format
remote_url=$(convert_url "$remote_url")

# Get current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get relative path from repo root (if any)
repo_root=$(git rev-parse --show-toplevel)
current_dir=$(pwd)
relative_path=""

if [ "$repo_root" != "$current_dir" ]; then
    relative_path=${current_dir#$repo_root/}
fi

# Add path based on hosting service
if [[ "$remote_url" == *"github.com"* ]]; then
    if [ ! -z "$relative_path" ]; then
        remote_url="$remote_url/tree/$current_branch/$relative_path"
    else
        remote_url="$remote_url/tree/$current_branch"
    fi
elif [[ "$remote_url" == *"gitlab"* ]]; then
    if [ ! -z "$relative_path" ]; then
        remote_url="$remote_url/-/tree/$current_branch/$relative_path"
    else
        remote_url="$remote_url/-/tree/$current_branch"
    fi
elif [[ "$remote_url" == *"bitbucket.org"* ]]; then
    if [ ! -z "$relative_path" ]; then
        remote_url="$remote_url/src/$current_branch/$relative_path"
    else
        remote_url="$remote_url/src/$current_branch"
    fi
fi

echo "Opening: $remote_url"

# Open URL based on OS
case "$(uname)" in
    "Darwin")  # macOS
        open "$remote_url"
        ;;
    "Linux")
        if command -v xdg-open > /dev/null; then
            xdg-open "$remote_url"
        elif command -v gnome-open > /dev/null; then
            gnome-open "$remote_url"
        else
            echo "Error: Could not detect a way to open the URL"
            echo "Please open this URL in your browser: $remote_url"
            exit 1
        fi
        ;;
    "MINGW"*|"MSYS"*|"CYGWIN"*)  # Windows
        start "$remote_url" || echo "Please open this URL in your browser: $remote_url"
        ;;
    *)
        echo "Unsupported operating system"
        echo "Please open this URL in your browser: $remote_url"
        exit 1
        ;;
esac