# Bootstrap script

```shell
# Install command line tools
xcode-select --install

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# Run the script
NIX_CONFIG="experimental-features = nix-command flakes" nix run github:bdura/bootstrap.#bootstrap
```
