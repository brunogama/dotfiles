{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  npmBin = "${config.xdg.dataHome}/dotfiles/npm/current/node_modules/.bin";
  legacyLinks = [
    {
      target = ".zshenv";
      source = ../zsh/.zshenv;
    }
    {
      target = ".config/zsh/.zshrc";
      source = ../zsh/.zshrc;
    }
    {
      target = ".config/zsh/.zprofile";
      source = ../zsh/.zprofile;
    }
    {
      target = ".config/zsh/.zpreztorc";
      source = ../zsh/.zpreztorc;
    }
    {
      target = ".config/starship.toml";
      source = ../zsh/starship.toml;
    }
    {
      target = ".config/zsh/work-config.zsh";
      source = ../zsh/work-config.zsh;
    }
    {
      target = ".config/zsh/personal-config.zsh";
      source = ../zsh/personal-config.zsh;
    }
    {
      target = ".config/zsh/lib/lazy-load.zsh";
      source = ../zsh/lib/lazy-load.zsh;
    }
    {
      target = ".config/zsh/completion/_pi";
      source = ../zsh/completion/_pi;
    }
    {
      target = ".config/zsh/completion/git-ignore-completion";
      source = ../zsh/completion/git-ignore-completion;
    }
    {
      target = ".gitconfig";
      source = ../git/.gitconfig;
    }
    {
      target = ".gitignore_global";
      source = ../git/.gitignore_global;
    }
    {
      target = ".config/git/github-flow-aliases.gitconfig";
      source = ../git/github-flow-aliases.gitconfig;
    }
    {
      target = ".config/git/conventional-commits-gitmessage";
      source = ../git/conventional-commits-gitmessage;
    }
    {
      target = ".config/git/ios.gitattributes";
      source = ../git/ios.gitattributes;
    }
  ];
  legacyLinkSource =
    link:
    pkgs.writeText "legacy-dotfile-${builtins.substring 0 12 (builtins.hashString "sha256" link.target)}" (
      builtins.readFile link.source
    );
  legacyLinkCommands = lib.concatMapStringsSep "\n" (
    link:
    "migrate_legacy_link ${lib.escapeShellArg link.target} ${lib.escapeShellArg (legacyLinkSource link)}"
  ) legacyLinks;
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

  home.activation.migrateLegacyDotfileLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    migrate_legacy_link() {
      local relative="$1"
      local expected="$2"
      local target="$HOME/$relative"
      local backup="$target.pre-nix"

      if [[ ! -L "$target" ]] || ! cmp -s -- "$target" "$expected"; then
        return 0
      fi

      if [[ -e "$backup" || -L "$backup" ]]; then
        rm -- "$target"
      else
        mv -- "$target" "$backup"
      fi
      echo "Home Manager migration: preserved $target as $backup" >&2
    }

    ${legacyLinkCommands}
  '';

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
    ".pi/agent/AGENTS.md".source = ../docs/agents/AGENTS.md;
    ".codex/AGENTS.md".source = ../docs/agents/AGENTS.md;
    ".claude/CLAUDE.md".source = ../docs/agents/AGENTS.md;

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
