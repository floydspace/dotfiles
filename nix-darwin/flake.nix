{
  description = "Floydspace darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages =
        [ 
          pkgs.alacritty
          pkgs.bun
          pkgs.deno
          pkgs.iterm2
          pkgs.slack
          pkgs.vim
        ];

      # homebrew = {
      #   enable = true;
      # };

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.defaults = {
        dock.autohide = false;
        finder.FXPreferredViewStyle = "Nlsv";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleShowAllExtensions = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#default
    darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        # nix-homebrew.darwinModules.nix-homebrew
        # {
        #   nix-homebrew = {
        #     # Install Homebrew under the default prefix
        #     enable = true;

        #     # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
        #     # enableRosetta = true;

        #     # User owning the Homebrew prefix
        #     user = "victor";

        #     # Automatically migrate existing Homebrew installations
        #     autoMigrate = true;
        #   };
        # }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."default".pkgs;
  };
}
