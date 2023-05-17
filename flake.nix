{
  description = "Nix Machina";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, devenv }:
    let
      overlays = [
        (final: prev: {
          devenv = inputs.devenv.packages.${prev.system}.devenv;
        })
      ];
    in {
      darwinConfigurations = {
        "macbook" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./macos
          ];
          inputs = { inherit darwin home-manager nixpkgs; };
        };
      };
    };
}
