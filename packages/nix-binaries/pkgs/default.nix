# Package definitions organized by category
{ pkgs }:

{
  # Core Unix utilities - available on all platforms
  unix-tools = with pkgs; [
    bat
    coreutils
    curl
    wget
    tree
    unzip
    zip
    fd
    fzf
    ripgrep
    jq
    sd
    grex
  ];

  # Version control
  git-tools = with pkgs; [
    git
    gh
    git-delta
    git-flow
    git-lfs
    git-secrets
    gitleaks
  ];

  # Development environment
  dev-tools = with pkgs; [
    neovim
    tmux
    shellcheck
    clang-tools
    pre-commit
    lefthook
    watchman
  ];

  # Language runtimes
  runtimes = with pkgs; [
    python311
    python39
    nodejs_20
    ruby_3_3
    kotlin
  ];

  # Language version managers
  version-managers = with pkgs; [
    pyenv
    rbenv
  ];

  # Code analysis & formatting (Unix-compatible)
  code-tools = with pkgs; [
    swiftformat
    swiftlint
    tokei
    ripgrep
    shellcheck
  ];

  # CLI utilities
  utilities = with pkgs; [
    eza
    dust
    procs
    htop
    ncdu
    zoxide
    choose
    the_silver_searcher
    tldr
    terminal-notifier
  ];

  # Network & debugging
  network-tools = with pkgs; [
    httpie
    hyperfine
    binwalk
  ];

  # Infrastructure & platform tools
  platform-tools = with pkgs; [
    docker
    gnupg
    stow
    tmux
    zsh
  ];

  # All tools combined
  all =
    (builtins.concatLists [
      (with pkgs; unix-tools)
      (with pkgs; git-tools)
      (with pkgs; dev-tools)
      (with pkgs; runtimes)
      (with pkgs; version-managers)
      (with pkgs; code-tools)
      (with pkgs; utilities)
      (with pkgs; network-tools)
      (with pkgs; platform-tools)
    ]);
}
