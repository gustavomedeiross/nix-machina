{
  description = "Nix Machina";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Remove once this is done: https://github.com/nix-community/home-manager/issues/1341
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      mac-app-util,
    }:
    let
      overlays = [
        (import (
          builtins.fetchTarball {
            url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
          }
        ))
      ];
    in
    {
      darwinConfigurations = {
        "macbook" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            mac-app-util.darwinModules.default
            ./macos
          ];
          inputs = {
            inherit
              darwin
              home-manager
              nixpkgs
              mac-app-util
              ;
          };
        };
      };
    };
}
