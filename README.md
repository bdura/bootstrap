# Bootstrap script

```shell
# Install command line tools
xcode-select --install

# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Run the script
nix run github:bdura/bootstrap.#bootstrap
```
