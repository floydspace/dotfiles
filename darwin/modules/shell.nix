#
#  Shell Configuration - Zsh, Oh-My-Zsh, Powerlevel10k
#
#  flake.nix
#   └─ ./darwin
#       ├─ darwin-configuration.nix
#       └─ ./modules
#           ├─ default.nix
#           └─ shell.nix *
#

{ pkgs, vars, ... }:

{
  # Install Powerlevel10k
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];

  home-manager.users.${vars.user} = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = false;
      
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "npm"
          "aws"
          "terraform"
          "heroku"
          "docker"
          "command-not-found"
          # wakatime - loaded via custom plugins
          # zsh-nvm - loaded via custom plugins
        ];
        custom = "$HOME/.oh-my-zsh/custom";
        theme = "powerlevel10k/powerlevel10k";
      };
      
      shellAliases = {
        zshrc = "code ~/.zshrc";
        ohmyzsh = "code ~/.oh-my-zsh";
        awsp = "source _awsp";
        assume = ". assume";
      };
      
      initContent = ''
        # Direnv export (must be at top for instant prompt)
        (( ''${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
        
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        
        # Custom fpath additions
        fpath=(~/.zsh $fpath)
        fpath=(~/.granted/zsh_autocomplete/assume/ $fpath)
        fpath=(~/.granted/zsh_autocomplete/granted/ $fpath)
        
        # Additional completion initialization
        autoload -Uz compinit bashcompinit
        compinit
        bashcompinit
        
        # Direnv hook (after Oh-My-Zsh)
        (( ''${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
        
        # P10K configuration
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        
        # Cargo environment
        [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
        
        # Corporate-specific environment variables (not managed by Nix)
        [ -f "$HOME/.zsh_corporate" ] && source "$HOME/.zsh_corporate"
      '';
    };
    
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
