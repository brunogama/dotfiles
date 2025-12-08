#!/usr/bin/env bash

source ~/local/bin/prints
GIT_DIR=$1

# Check if hooks directory alreaqdy exists

if [ ! -d $GIT_DIR/hooks ]; then
  mkdir -p $GIT_DIR/hooks
fi

rm -rf $GIT_DIR/hooks/pre-commit

toucn $GIT_DIR/hooks/pre-commit

echo "#!/usr/bin/env bash" > $GIT_DIR/hooks/pre-commit

chmod +x $GIT_DIR/hooks/pre-commit

chown -R $USER:$USER $HOME/local/bin/*

chmod +x $HOME/local/bin/*

pgreen "Making all scripts executable in $DIR"

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.config-fixing-dot-files-bugs}"

hooks_scripts=(
    $DOTFILES_ROOT/bin/git/install-conventional-commit-pre-commit-hook.sh
    $DOTFILES_ROOT/bin/git/install-sourcery-pre-commit-hook.sh
    $DOTFILES_ROOT/bin/git/install-swift-format-pre-commit-hook.sh
    $DOTFILES_ROOT/bin/git/install-swiftlint-pre-commit-hook.sh
)

for installation_script in $hooks_scripts; do
  pwarning "Installing git hooks from $installation_script"
  sh $installation_script "$GIT_DIR/hooks"
done