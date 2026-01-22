#
#  Development Tools Configuration
#  FNM, Pyenv, SDKMAN, Bun, Docker, OpenCode, Rust
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
    home.packages = with pkgs; [
      rustup  # Rust toolchain manager
      zig     # Zig programming language
    ];
    
    programs.zsh.initContent = ''
      # FNM (Fast Node Manager) - 40x faster than NVM
      # --use-on-cd: auto-switch on directory change
      # --resolve-engines: respect package.json engines field
      eval "$(fnm env --use-on-cd --resolve-engines)"
      
      # FNM: Revert to default when leaving .nvmrc directories
      _fnm_autoload_hook() {
        if [[ -f .nvmrc || -f .node-version ]]; then
          fnm use --silent-if-unchanged 2>/dev/null
        elif [[ -e "$FNM_DIR/aliases/default" ]]; then
          # Only switch to default if we're not already on it
          local current_version=$(fnm current 2>/dev/null)
          local default_version=$(basename "$(dirname "$(readlink "$FNM_DIR/aliases/default")")")
          if [[ "$current_version" != "$default_version" ]]; then
            fnm use default --silent-if-unchanged 2>/dev/null || true
          fi
        fi
      }
      autoload -U add-zsh-hook
      add-zsh-hook chpwd _fnm_autoload_hook
      
      # Pyenv initialization
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init --path)"
      eval "$(pyenv virtualenv-init -)"
      
      # Bun completions
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      
      # GHCup (Haskell toolchain) - lazy loaded for faster startup
      export GHCUP_INSTALL_BASE_PREFIX="$HOME"
      ghcup() {
        if [[ -f "$HOME/.ghcup/env" ]]; then
          source "$HOME/.ghcup/env"
          unfunction ghcup
          ghcup "$@"
        fi
      }
      ghci() {
        if [[ -f "$HOME/.ghcup/env" ]]; then
          source "$HOME/.ghcup/env"
          unfunction ghcup ghci
          ghci "$@"
        fi
      }
      
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
