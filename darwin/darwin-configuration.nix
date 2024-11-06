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

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "Monaspace" ]; })
  ];

  environment = {
    systemPackages = with pkgs; [
      # git # There is some issue with OpenSSL when pushing to github
      # zsh-powerlevel10k # Prompt
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
      "git"
    ];
  };

  home-manager.users.${vars.user} = {
    home.stateVersion = "22.05";
  };

  services.nix-daemon.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Enable TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

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