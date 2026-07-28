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

  networking = {
    computerName = host.computerName;
    hostName = host.hostName;
    localHostName = host.localHostName;
  };

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
        AppleInterfaceStyleSwitchesAutomatically = true;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = true;
        "com.apple.springing.delay" = 0.5;
        "com.apple.springing.enabled" = true;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.forceClick" = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      finder = {
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Recents";
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        minimize-to-application = true;
        orientation = "bottom";
        persistent-apps = [
          "/System/Applications/Apps.app"
          "/Applications/Safari.app"
          "/System/Applications/Reminders.app"
          "/System/Applications/Music.app"
          "/System/Applications/System Settings.app"
        ];
        persistent-others = [
          {
            folder = {
              path = "${homeDirectory}/Downloads";
              arrangement = "date-added";
              displayas = "stack";
              showas = "fan";
            };
          }
        ];
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        tilesize = 41;
        wvous-br-corner = 14;
      };

      menuExtraClock = {
        ShowAMPM = true;
        ShowDate = 0;
        ShowDayOfWeek = true;
      };

      ActivityMonitor = {
        OpenMainWindow = true;
        ShowCategory = 102;
      };

      iCal.CalendarSidebarShown = false;
      hitoolbox.AppleFnUsageType = "Start Dictation";

      WindowManager = {
        AppWindowGroupingBehavior = true;
        AutoHide = false;
        EnableTiledWindowMargins = false;
        HideDesktop = true;
        StageManagerHideWidgets = false;
        StandardHideWidgets = false;
      };

      screencapture = {
        location = "${homeDirectory}/Desktop";
        type = "png";
        disable-shadow = true;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleLanguages = [
            "pt-BR"
            "en-BR"
          ];
          AppleLocale = "pt_BR";
          AppleMiniaturizeOnDoubleClick = false;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder".ShowSidebar = true;
        "com.apple.iCal".enableTravelAdvisoriesForAutomaticBehavior = true;
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
