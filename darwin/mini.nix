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
      discord
      slack
    ];
  };

  homebrew = {
    brews = [
      "docker"
      "ios-webkit-debug-proxy"
      "jpeg"
      "rabbitmq"
      "sqlite"
      "wireguard-go"
      "wireguard-tools"
    ];
    # masApps = {
    # };
  };
}