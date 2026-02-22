{
  description = "Bootstrap script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        bootstrap = pkgs.writeShellApplication {
          name = "bootstrap";
          runtimeInputs = with pkgs; [
            bitwarden-cli
            jq
            git
            nh
            stow
          ];
          text = builtins.readFile ./scripts/bootstrap.sh;
        };
      in
      {
        apps.bootstrap = {
          type = "app";
          program = "${bootstrap}/bin/bootstrap";
        };
      }
    );
}
