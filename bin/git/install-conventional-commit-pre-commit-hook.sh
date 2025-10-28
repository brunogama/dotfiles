#!/usr/bin/env bash

source ${HOME}/.local/bin/prints
GIT_DIR="$1"
HOOKS_DIR="$GIT_DIR/.git/hooks"

install_hook() {
    local repo_path="$1"
    DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.config-fixing-dot-files-bugs}"
    local hook="$DOTFILES_ROOT/bin/git/git-hooks/pre-commit-conventional-commit-msg"
    local hooks_dir="$HOOKS_DIR"

    mkdir -p "$hooks_dir"

    if [ -f "$hooks_dir/pre-commit" ]; then
        pwarning "A pre-commit hook already exists in ${repo_path}"

        read -p "Do you want to overwrite the existing pre-commit hook or merge with it? Overwrite/Merge (o/m) Any other key will exit" -n 1 -r

        if [[ $REPLY =~ ^[Oo]$ ]]; then
            echo -e "${YELLOW}Overwriting the pre-commit hook...${NC}"
            rm "$hooks_dir/pre-commit"
            touch "$hooks_dir/pre-commit"
            echo "#!/usr/bin/env bash" > "$hooks_dir/pre-commit"
            echo "" >> "$hooks_dir/pre-commit"
            echo "# $0" >> "$hooks_dir/pre-commit"
            echo "$hook" >> "$hooks_dir/pre-commit"

        else
            pwarning "Adding ${BLUE}\"$0\"${YELLOW} the pre-commit hook...${NC}"
            echo "" >> "$hooks_dir/pre-commit"
            echo "# $0" >> "$hooks_dir/pre-commit"
            echo "$hook" >> "$hooks_dir/pre-commit"
        fi
    else
        rm -rf "$hooks_dir/pre-commit"
        touch "$hooks_dir/pre-commit"
        echo "#!/usr/bin/env bash" > "$hooks_dir/pre-commit"
        echo "" >> "$hooks_dir/pre-commit"
        echo "# $0" >> "$hooks_dir/pre-commit"
        echo "$hook" >> "$hooks_dir/pre-commit"
    fi

    chmod +x "$hooks_dir/pre-commit"

    psuccess "Installed ${BLUE}$0${GREEN} hook in ${repo_path}${NC}"
}

cd $GIT_DIR

# Check if current directory is a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Current directory is not a git repository${NC}"
    exit 1
fi

# Install hook in main repository
install_hook "$GIT_DIR"

# Check if repository has submodules
if [ -f ".gitmodules" ]; then
    pwarning "Installing hooks in submodules..."

    # Get all submodule paths
    submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')

    # Install hook in each submodule
    for submodule in $submodules; do
        if [ -d "$submodule/.git" ]; then
            install_hook "${submodule}"
        else
            echo -e "${YELLOW}Skipping $submodule - not initialized${NC}"
        fi
    done
fi

function install_gitmessage() {
    local GIT_DIR="$1"
    cd $GIT_DIR
    rm -rf "${GIT_DIR}/.gitmessage"
cat > "${GIT_DIR}/.gitmessage" << 'EOL'
# <type>[(scope)][!]: <description>
# |<----   Using a Maximum Of 50 Characters   ---->|

# [optional body]
# |<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

# [optional footer(s)]
# BREAKING CHANGE: <description>
# Fixes: #<issue number>

# feat:     A new feature
# fix:      A bug fix
# docs:     Documentation only changes
# style:    Changes that do not affect the meaning of the code
# refactor: A code change that neither fixes a bug nor adds a feature
# perf:     A code change that improves performance
# test:     Adding missing tests or correcting existing tests
# build:    Changes that affect the build system or external dependencies
# ci:       Changes to CI configuration files and scripts
# chore:    Changes to the build process or auxiliary tools
EOL
    if [ -f "${GIT_DIR}/.gitmessage" ]; then
        git config commit.template ${GIT_DIR}/.gitmessage
    fi

    psuccess -e "Hook installation completed!"
    psuccess -e "Created .gitmessage template"
}

pwarning "Do your want to install conventional commits template? [y/n]?"
read -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_gitmessage "${GIT_DIR}"
fi

exit 0
