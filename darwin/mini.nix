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
      "bash"
      "docker"
      "ios-webkit-debug-proxy"
      "jpeg"
      "mongodb"
      "node"
      "openssl"
      "pkg-config"
      "python@2"
      "rabbitmq"
      "readline"
      "sqlite"
      "usbmuxd"
      "wireguard-go"
      "wireguard-tools"
      "wxmac"
      "wxwidgets"
      "yarn"
    ];
    # masApps = {
    # };
  };
}