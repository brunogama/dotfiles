#!/usr/bin/env bash

source ~/.config/bin/prints
GIT_DIR=$1

# Check if hooks directory alreaqdy exists

if [ ! -d $GIT_DIR/hooks ]; then
  mkdir -p $GIT_DIR/hooks
fi

rm -rf $GIT_DIR/hooks/pre-commit

toucn $GIT_DIR/hooks/pre-commit

echo "#!/usr/bin/env bash" > $GIT_DIR/hooks/pre-commit

chmod +x $GIT_DIR/hooks/pre-commit

chown -R $USER:$USER $HOME/.config/*

chmod +x $HOME/.config/bin/*

pgreen "Making all scripts executable in $DIR"

hooks_scripts=(
    $HOME/.config/git/scripts/install-conventional-commit-pre-commit-hook.sh
    $HOME/.config/git/scripts/install-sourcery-pre-commit-hook.sh
    $HOME/.config/git/scripts/install-swift-format-pre-commit-hook.sh
    $HOME/.config/git/scripts/install-swiftlint-pre-commit-hook.sh
)

for installation_script in $hooks_scripts; do
  pwarning "Installing git hooks from $installation_script"
  sh $installation_script "$GIT_DIR/hooks"
done