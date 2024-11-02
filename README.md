How to apply nix-darwin configuration:

```sh
darwin-rebuild switch --flake "./nix-darwin#default"
```

Update packages:
    
```sh
nix flake update --flake "./nix-darwin"
darwin-rebuild switch --flake "./nix-darwin#default"
```

Cleanup unused packages:

```sh
nix-collect-garbage -d
```