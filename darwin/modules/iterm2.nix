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

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}