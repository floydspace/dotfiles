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

  # homebrew = {
  #   masApps = {
  #   };
  # };
}