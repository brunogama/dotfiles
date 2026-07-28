{ pkgs }:
with pkgs;
[
  actionlint
  bat
  bats
  curl
  eza
  ffmpeg
  fzf
  gh
  git
  git-lfs
  httpie
  jq
  nodejs_24
  pandoc
  perl
  poppler-utils
  pre-commit
  python313
  repomix
  ripgrep
  rtk
  ruby_3_4
  shellcheck
  starship
  tmux
  tree
  uv
  yq-go
  zoxide
  zsh-prezto
]
++ lib.optionals stdenv.isDarwin [ tuist ]
