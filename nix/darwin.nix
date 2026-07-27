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
    vscode = [ "anysphere.remote-ssh" ];
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
  };

  environment.systemPackages = [ pkgs.zsh ];
}
