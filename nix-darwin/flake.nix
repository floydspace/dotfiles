{
  description = "Floydspace darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages =
        [ 
          pkgs.bun
          pkgs.deno
          # pkgs.direnv # There is some issue with zsh config
          pkgs.gh
          # pkgs.git # There is some issue with OpenSSL when pushing to github
          pkgs.go
          pkgs.goreleaser
          # pkgs.iterm2
          pkgs.jq
          pkgs.slack
          pkgs.vim
          pkgs.zoom-us
        ];

      homebrew = {
        enable = true;
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
          "iterm2"
          "kdiff3"
          "mongodb-compass"
          "postman"
          "sourcetree"
          "spotify"
        ];
        masApps = {
          Telegram = 747648890;
          WireGuard = 1451685025;
          "WhatsApp Messenger" = 310633997;
          Xcode = 497799835;
        };
        onActivation.cleanup = "zap";
      };

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
