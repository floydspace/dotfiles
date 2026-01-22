Install `nix` and `nix-darwin`:

```sh
# 1. Optionally, set the path to your custom certificate
export NIX_INSTALLER_SSL_CERT_FILE=/path/to/your/certificate.pem

# 2. Install `nix` with determinate.systems installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 3. Install `nix-darwin` with flake
nix run nix-darwin -- switch --flake ".#MacBookM2Pro"
```

How to apply nix-darwin configuration:

```sh
darwin-rebuild switch --flake ".#MacBookM2Pro"
```

Update packages:
    
```sh
nix flake update

darwin-rebuild switch --flake ".#MacBookM2Pro"
```

Cleanup unused packages:

```sh
nix-collect-garbage -d
```

## Troubleshooting

- Failed to recognize my M2 Pro Macbook system architecture:
  ```sh
  error: a 'aarch64-darwin' with features {} is required to build '/nix/store/31l4y3kn5cf5a9xpp4q65rkpdm0kx2sr-activate-system-start.drv', but I am a 'x86_64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
  ```
  It happened on my M2 Pro Macbook. I had to explicitly set the `system` to `aarch64-darwin` in `/etc/nix/nix.conf`

- Failed to download from remote due to certificate error:
  ```sh
  warning: error: unable to download 'https://cache.nixos.org/8n8a23azcm8smr1q6xk77jb2pgxa518f.narinfo': SSL peer certificate or SSH remote key was not OK (60); retrying in 310 ms
  ```
  I had to explicitly set the path to my employer's certificate (which is enforced or my laptop) as `ssl-cert-file` in `/etc/nix/nix.conf` and as `NIX_SSL_CERT_FILE` in `/Library/LaunchDaemons/org.nixos.nix-daemon.plist`.

  Then, I had to restart the `nix-daemon` service:
  ```sh
  sudo launchctl kickstart -k system/org.nixos.nix-daemon
  ```

## References

- [Nix-Darwin Fresh Install guide](https://github.com/MatthiasBenaets/nix-config/blob/master/darwin.org) by [Matthias Benaets](https://github.com/MatthiasBenaets)
- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [nix-darwin](https://github.com/LnL7/nix-darwin)