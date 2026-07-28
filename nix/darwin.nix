{
  config,
  host,
  pkgs,
  self,
  ...
}:
let
  homeDirectory = "/Users/${host.username}";
in
{
  nixpkgs.hostPlatform = host.system;

  nix = {
    enable = host.manageNix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.zsh.enable = true;

  # The upstream Nix 2.35 daemon installer prepends its initialization block to
  # Apple's stock shell files. These exact hashes contain no user customization;
  # allowing them lets nix-darwin preserve each original as
  # *.before-nix-darwin during first activation instead of aborting.
  environment.etc."bashrc".knownSha256Hashes = [
    "8b5e3466922d1ae34bc145e21c7e53e7329a7a7b58b148b436bd954d5e651ac3"
  ];
  environment.etc."zshrc".knownSha256Hashes = [
    "cf0f7b7775b4c058d6085d9e7e57d58c307ca43730f8e4d921a9ef4e530e7e16"
  ];

  users.users.${host.username} = {
    home = homeDirectory;
    shell = pkgs.zsh;
  };

  system = {
    primaryUser = host.username;
    stateVersion = 7;
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
        _FXSortFoldersFirst = true;
        FXPreferredViewStyle = "Nlsv";
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true;
      };

      dock = {
        orientation = "bottom";
        autohide = true;
        showhidden = true;
        show-recents = false;
        tilesize = 74;
        minimize-to-application = true;
        show-process-indicators = true;
      };

      screencapture = {
        location = "${homeDirectory}/Desktop";
        type = "png";
        disable-shadow = true;
      };

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          AutomaticDownload = true;
          CriticalUpdateInstall = true;
        };
        "com.apple.terminal".SecureKeyboardEntry = true;
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      };
    };
  };

  homebrew = {
    enable = true;
    enableZshIntegration = false;
    brews = [ "sourcekitten" ];
    casks = [ "fork" ];
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
  };

  environment.systemPackages = [ pkgs.zsh ];
}
