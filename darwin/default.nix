#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       ├─ darwin-configuraiton.nix
#       └─ <host>.nix
#

{ inputs, nixpkgs, darwin, home-manager, ... }:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  MacBookM2Pro =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs stable;
      vars = {
        user = "victor";
      };
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs system pkgs stable vars; };
      modules = [
        ./darwin-configuration.nix
        ./m2pro.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

  MacMini =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs stable;
      vars = {
        user = "admin";
      };
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs system pkgs stable vars; };
      modules = [
        ./darwin-configuration.nix
        ./mini.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}