#
#  Main MacOS system configuration.
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ darwin-configuration.nix *
#       └─ ./modules
#           └─ default.nix
#

{ inputs, pkgs, vars, ... }:

{
  imports = (import ./modules);

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
    #   git # Version Control
    #   mas # Mac App Store $ mas search <app>
      ranger # File Manager
    #   tldr # Help
    #   zsh-powerlevel10k # Prompt
    ];
  };

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "awscli"
      "applesimutils"
      "aws-sso-creds"
      "aws-sso-util"
      "certifi"
      "cocoapods"
      "direnv"
      "flyctl"
      "git"
      "ios-deploy"
      "localstack-cli"
      "rbenv"
      "ruby"
      "scrcpy"
      "telnet"
      "tfenv"
    ];
    taps = [
      "jaxxstorm/tap"
      "localstack/tap"
      "wix/brew"
    ];
    casks = [
      "drawio"
      "figma"
      "kdiff3"
      "mongodb-compass"
      "postman"
      "sourcetree"
      "spotify"
    ];
    masApps = {
      "Telegram" = 747648890;
      "WireGuard" = 1451685025;
      "WhatsApp Messenger" = 310633997;
    };
  };

  home-manager.users.${vars.user} = {
    home.stateVersion = "22.05";
  };

  services.nix-daemon.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = 5;
}