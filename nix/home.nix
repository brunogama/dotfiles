{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  npmBin = "${config.xdg.dataHome}/dotfiles/npm/current/node_modules/.bin";
in
{
  home = {
    username = host.username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.05";
    packages = import ./packages.nix { inherit pkgs; };

    sessionPath = [
      "${config.home.homeDirectory}/local/bin"
      "${config.home.homeDirectory}/.local/bin"
      npmBin
    ];

    sessionVariables = {
      DOTFILES_NPM_BIN = npmBin;
      UV_NATIVE_TLS = "1";
      ZPREZTODIR = "${pkgs.zsh-prezto}/share/zsh-prezto";
    };
  };

  xdg.enable = true;

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = host.git;
        core.excludesFile = "${config.home.homeDirectory}/.gitignore_global";
        include.path = "${config.xdg.configHome}/git/github-flow-aliases.gitconfig";
        push.autoSetupRemote = true;
      };
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = false;
      envExtra = builtins.readFile ../zsh/.zshenv;
      profileExtra = builtins.readFile ../zsh/.zprofile;
      initContent = lib.mkOrder 1000 (builtins.readFile ../zsh/.zshrc);
    };
  };

  home.file = {
    ".gitignore_global".source = ../git/.gitignore_global;
    ".config/git/github-flow-aliases.gitconfig".source = ../git/github-flow-aliases.gitconfig;
    ".config/git/conventional-commits-gitmessage".source = ../git/conventional-commits-gitmessage;
    ".config/git/ios.gitattributes".source = ../git/ios.gitattributes;

    ".config/zsh/.zpreztorc".source = ../zsh/.zpreztorc;
    ".config/starship.toml".source = ../zsh/starship.toml;
    ".config/zsh/work-config.zsh".source = ../zsh/work-config.zsh;
    ".config/zsh/personal-config.zsh".source = ../zsh/personal-config.zsh;
    ".config/zsh/lib" = {
      source = ../zsh/lib;
      recursive = true;
    };
    ".config/zsh/completion" = {
      source = ../zsh/completion;
      recursive = true;
    };
  };
}
