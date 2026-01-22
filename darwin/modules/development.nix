#
#  Development Tools Configuration
#  NVM, Pyenv, SDKMAN, Bun, McFly, Docker, OpenCode
#
#  flake.nix
#   └─ ./darwin
#       ├─ darwin-configuration.nix
#       └─ ./modules
#           ├─ default.nix
#           └─ development.nix *
#

{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs.zsh.initContent = ''
      # NVM initialization
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      
      # Pyenv initialization
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init --path)"
      eval "$(pyenv virtualenv-init -)"
      
      # Bun completions
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      
      # McFly shell history (ctrl-r replacement)
      eval "$(mcfly init zsh)"
      
      # GHCup (Haskell toolchain)
      [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
      
      # Docker CLI completions
      fpath=($HOME/.docker/completions $fpath)
      
      # OpenCode completions
      #compdef opencode
      _opencode_yargs_completions() {
        local reply
        local si=$IFS
        IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "''${words[@]}"))
        IFS=$si
        if [[ ''${#reply} -gt 0 ]]; then
          _describe 'values' reply
        else
          _default
        fi
      }
      if [[ "''${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
        _opencode_yargs_completions "$@"
      else
        compdef _opencode_yargs_completions opencode
      fi
      
      # SDKMAN initialization (must be at the end)
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };
}
