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

{ pkgs, vars, ... }:

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

#   nix = {
#     package = pkgs.nix;
#     gc = {
#       automatic = true;
#       interval.Day = 7;
#       options = "--delete-older-than 7d";
#     };
#     extraOptions = ''
#       # auto-optimise-store = true
#       experimental-features = nix-command flakes
#     '';
#   };

  system = {
    stateVersion = 5;
  };
}