#
#  Environment Variables Configuration
#  Java, Android, pnpm, and PATH management
#
#  flake.nix
#   └─ ./darwin
#       ├─ darwin-configuration.nix
#       └─ ./modules
#           ├─ default.nix
#           └─ environment.nix *
#
#  Note: Corporate-specific variables (NODE_EXTRA_CA_CERTS, npm registry)
#        remain in ~/.zshenv for easier per-company updates

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.sessionVariables = {
      # Java Development Kit
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
      
      # Android SDK
      ANDROID_HOME = "$HOME/Library/Android/sdk";
      
      # pnpm package manager
      PNPM_HOME = "$HOME/Library/pnpm";
    };
    
    home.sessionPath = [
      "$HOME/bin"
      "/usr/local/bin"
      "/opt/homebrew/bin"
      "$HOME/.ghcup/bin"
      "$HOME/.local/bin"
      "$ANDROID_HOME/emulator"
      "$ANDROID_HOME/platform-tools"
      "$PNPM_HOME"
    ];
  };
}
