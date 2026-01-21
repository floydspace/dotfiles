# AGENTS.md - Dotfiles Repository Guide

This is a **Nix-based macOS system configuration repository** using `nix-darwin` and flakes.
All configuration is declarative using the Nix expression language.

## Repository Structure

```
.dotfiles/
├── flake.nix                      # Main flake configuration (entry point)
├── flake.lock                     # Locked dependency versions
└── darwin/                        # macOS-specific configurations
    ├── default.nix                # Profile definitions (MacBookM2Pro, MacMini)
    ├── darwin-configuration.nix   # Shared system config (fonts, zsh, homebrew, nix)
    ├── m2pro.nix                  # MacBook M2 Pro specific packages/settings
    ├── mini.nix                   # Mac Mini specific packages/settings
    └── modules/                   # Reusable configuration modules
        ├── default.nix            # Module loader
        ├── alacritty.nix          # Alacritty terminal config
        ├── iterm2.nix             # iTerm2 terminal config
        └── kitty.nix              # Kitty terminal config
```

## Build/Apply Commands

### Initial Installation
```bash
# Set custom certificate (if needed for corporate networks)
export NIX_INSTALLER_SSL_CERT_FILE=/path/to/your/certificate.pem

# Install Nix with Determinate Systems installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Install nix-darwin with flake
nix run nix-darwin -- switch --flake ".#MacBookM2Pro"
```

### Apply Configuration Changes
```bash
darwin-rebuild switch --flake ".#MacBookM2Pro"
# or for Mac Mini:
darwin-rebuild switch --flake ".#MacMini"
```

### Update Packages
```bash
nix flake update --flake "./nix-darwin"
darwin-rebuild switch --flake ".#MacBookM2Pro"
```

### Cleanup
```bash
nix-collect-garbage -d  # Delete old generations and unused packages
```

### Available Profiles
- `MacBookM2Pro` - aarch64-darwin (Apple Silicon)
- `MacMini` - x86_64-darwin (Intel)

## Testing

There are no automated tests for this dotfiles repository. Validation is done through:
1. Nix evaluation (type checking happens during `darwin-rebuild`)
2. Manual verification after applying configurations
3. Flake lock ensures reproducible builds

## Code Style Guidelines

### File Structure
- All files use **2-space indentation** (no tabs)
- Files are named with **kebab-case** (e.g., `darwin-configuration.nix`)
- Attribute names use **camelCase** (e.g., `darwinConfigurations`)
- Variable names use **lowercase** (e.g., `vars`, `pkgs`)

### File Headers
Each `.nix` file should include a header showing its place in the hierarchy:
```nix
#
#  <Description of file purpose>
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       └─ <current-file.nix> *
#
```

### Nix Syntax
- **Imports**: Use relative paths (e.g., `import ./modules`)
- **String literals**: Use double quotes `"` for simple strings, single quotes `'` for multi-line config blocks (TOML, YAML)
- **Comments**: 
  - Use `#` for inline comments explaining why packages/configs are disabled
  - Document workarounds (e.g., `# git # There is some issue with OpenSSL when pushing to github`)
- **Attribute sets**: Align opening braces and indent consistently
- **Lists**: Use vertical alignment for readability when lists are long

### Package Management
- **Nix packages** (`environment.systemPackages`): For core CLI tools and development tools
- **Homebrew brews** (`homebrew.brews`): For tools with issues in Nix (git, direnv) or macOS-specific tools
- **Homebrew casks** (`homebrew.casks`): For GUI applications
- **Mac App Store** (`homebrew.masApps`): For commercial apps (use app ID numbers)

### Comments for Disabled Options
When commenting out packages or configurations, include a reason:
```nix
# direnv # There is some issue with zsh config
# discord # Not working in NN network
```

### System Preferences
- Group related settings together (NSGlobalDomain, finder, dock, etc.)
- Comment out unused sections but keep them for reference
- Add explanatory comments for non-obvious settings

## Git Commit Conventions

Use conventional commit prefixes:

- `fix:` - Adding missing packages, fixing configuration issues, bug fixes
- `chore:` - Maintenance tasks, updates to flake lock, dependency updates
- `feat:` - New features or major configuration additions
- `docs:` - Documentation updates

**Examples:**
```
fix: add copilot-cli, opencode, wakatime-cli to brew packages
chore: update nixpkgs, nix-darwin, and home-manager to latest revisions
feat: enable touch id for sudo
```

## Common Patterns

### Adding a New Package
1. Determine package source (nixpkgs, homebrew, cask, or mas)
2. Add to appropriate machine config (`m2pro.nix` or `mini.nix`)
3. Apply configuration: `darwin-rebuild switch --flake ".#MacBookM2Pro"`
4. Commit with `fix:` prefix

### Creating a New Module
1. Create file in `darwin/modules/`
2. Follow existing module patterns (alacritty.nix, kitty.nix)
3. Import must be added in `darwin/modules/default.nix`
4. Add header comment showing file hierarchy

### Updating Dependencies
1. Run `nix flake update --flake "./nix-darwin"`
2. Apply changes: `darwin-rebuild switch --flake ".#MacBookM2Pro"`
3. Test that system still works correctly
4. Commit with `chore:` prefix

## Variable Naming

- `vars` - User-specific variables (username, home directory)
- `pkgs` - Nixpkgs package set
- `inputs` - Flake inputs (nixpkgs, home-manager, darwin)

## Error Handling

No explicit error handling in Nix config files. Common issues:

1. **Architecture mismatch**: Set `system` in `/etc/nix/nix.conf`
2. **Certificate errors**: Set `ssl-cert-file` in `/etc/nix/nix.conf` and `NIX_SSL_CERT_FILE` in LaunchDaemon plist
3. **Nix daemon issues**: Restart with `sudo launchctl kickstart -k system/org.nixos.nix-daemon`

## Best Practices

1. **Keep configurations modular**: Use `modules/` for reusable configs
2. **Document workarounds**: Add comments for packages that don't work in Nix
3. **Test before committing**: Always apply changes with `darwin-rebuild` before committing
4. **Maintain flake.lock**: Commit lock file updates separately from feature changes
5. **Use shared configs**: Put common settings in `darwin-configuration.nix`
6. **Machine-specific only**: Keep machine-specific packages in `m2pro.nix`/`mini.nix`
7. **Garbage collection**: Nix automatically runs garbage collection weekly (configured in darwin-configuration.nix)

## Troubleshooting

See README.md for detailed troubleshooting of:
- M2 architecture recognition issues
- Certificate errors in corporate environments
- Nix daemon restart procedures
