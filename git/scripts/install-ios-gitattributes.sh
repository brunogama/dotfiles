#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
pwarning() {
    echo -e "${YELLOW}$1${NC}"
}

psuccess() {
    echo -e "${GREEN}$1${NC}"
}

perror() {
    echo -e "${RED}$1${NC}"
}

# Function to install gitattributes in a repository
install_gitattributes() {
    local repo_path="$1"
    
    # Copy the gitattributes file
    # Check if the file exists
    if [ ! -f ~/.config/git/ios.gitattributes ]; then
        perror "The ${BLUE}gitattributes${RED} file is missing. ${BLUE}\"Please make sure it exists at ${BLUE}\"${HOME}/.config/git/ios.gitattributes\""
        exit 1
    fi

    # Check if the repository already has a .gitattributes file
    if [ -f "$repo_path/.gitattributes" ]; then
        perror "The ${BLUE}\".gitattributes$\"{RED} file already exists in this ${BLUE}\"repository\"${BLUE}."
        perror "Do you want to overwrite it? (y/n) "
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        else
            pwarning "Overwriting the ${BLUE}\".gitattributes$\"${YELLOW} file..."
            cp ~/.config/git/ios.gitattributes "$repo_path/.gitattributes" 
        fi
    fi

    # Che k if git lfs is installed

    if ! command -v git-lfs &> /dev/null; then
        perror "Git LFS is not installed. Please install it with:"
        pwarning "> $ ${BLUE}brew install git-lfs${YELLOW}"
        exit 1
    fi
    
    # Initialize Git LFS if not already initialized
    cd "$repo_path"
    if ! git lfs status &>/dev/null; then
        pwarning "Initializing Git LFS in ${BLUE}\"${repo_path}\"${NC}"
        git lfs install

    else
        pwarning "${YELLOW}Git LFS is already initialized in ${BLUE}\"${repo_path}\"${NC}"
    fi
    
    psuccess "Installed ${BLUE}\".gitattributes\"${BLUE}${NC}${GREEN} in ${BLUE}\"${repo_path}\"${BLUE}${NC}${GREEN}}"

    # Check if repository has submodules
    if [ -f ".gitmodules" ]; then
        pwarning "Installing ${BLUE}\".gitattributes\"\"${BLUE}${NC}${YELLOW} in submodules...${NC}"
        
        # Get all submodule paths
        submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
        
        # Install gitattributes in each submodule
        for submodule in $submodules; do
            if [ -d "$submodule/.git" ]; then
                install_gitattributes "$(pwd)/$submodule"
            else
                echo -e "${YELLOW}Skipping $submodule - not initialized${NC}"
            fi
        done
    fi

    pwarning "Updating repository index..."

    git add -A
    git reset --hard HEAD

    psuccess "Installation completed!"
    pwarning "Note: You may need to run 'git lfs migrate import' if you have existing files that should be tracked by Git"
}

# Check if current directory is a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Current directory is not a git repository${NC}"
    exit 1
fi

install_gitattributes "$(pwd)"