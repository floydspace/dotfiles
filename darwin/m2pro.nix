#
#  Specific system configuration settings for the MacBook M2 Pro.
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       └─ ./m2pro.nix *
#

{ pkgs, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      bun
      deno
      # direnv # There is some issue with zsh config
      # discord # Not working in NN network
      gh
      # git # There is some issue with OpenSSL when pushing to github
      go
      goreleaser
      jq
      slack
      vim
      zoom-us
    ];
  };

  homebrew = {
    casks = [
    #   "docker"
    #   "docker-toolbox"
    #   "google-chrome"
      "obsidian"
      "upscayl"
    ];
    masApps = {
      "Microsoft Remote Desktop" = 1295203466;
      "Xcode" = 497799835;
    };
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        # NSAutomaticCapitalizationEnabled = false;
        # NSAutomaticSpellingCorrectionEnabled = false;
        # "com.apple.mouse.tapBehavior" = 1;
        # "com.apple.trackpad.enableSecondaryClick" = true;
        # "com.apple.keyboard.fnState" = true;
      };
    #   dock = {
    #     autohide = true;
    #     autohide-delay = 0.2;
    #     autohide-time-modifier = 0.1;
    #     magnification = true;
    #     mineffect = "scale";
    #     # minimize-to-application = true;
    #     orientation = "bottom";
    #     showhidden = false;
    #     show-recents = false;
    #     tilesize = 20;
    #   };
      finder = {
        # ShowPathbar = true;
        # ShowStatusBar = true;
        FXPreferredViewStyle = "Nlsv";
      };
    #   trackpad = {
    #     Clicking = true;
    #     TrackpadRightClick = true;
    #   };
    #   magicmouse = {
    #     MouseButtonMode = "TwoButton";
    #   };

    #   CustomUserPreferences = {
    #     # Settings of plist in ~/Library/Preferences/
    #     "com.apple.finder" = {
    #       # Set home directory as startup window
    #       NewWindowTargetPath = "file:///Users/${vars.user}/";
    #       NewWindowTarget = "PfHm";
    #       # Set search scope to directory
    #       FXDefaultSearchScope = "SCcf";
    #       # Multi-file tab view
    #       FinderSpawnTab = true;
    #     };
    #     "com.apple.desktopservices" = {
    #       # Disable creating .DS_Store files in network an USB volumes
    #       DSDontWriteNetworkStores = true;
    #       DSDontWriteUSBStores = true;
    #     };
    #     # Show battery percentage
    #     "~/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;
    #     # Privacy
    #     "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
    #   };
    #   CustomSystemPreferences = {
    #     # ~/Library/Preferences/

    #   };
    };
  };
}