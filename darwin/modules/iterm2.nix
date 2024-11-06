#
#  Terminal Emulator
#

{ pkgs, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      iterm2
    ];
  };
}