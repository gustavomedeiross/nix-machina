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
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Remove once this is done: https://github.com/nix-community/home-manager/issues/1341
    mac-app-util.url = "github:hraban/mac-app-util";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
      emacs-overlay,
      mac-app-util,
      rust-overlay,
    }:
    let
      overlays = [
        emacs-overlay.overlay
        rust-overlay.overlays.default
      ];
    in
    {
      darwinConfigurations = {
        "macbook" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            home-manager.darwinModules.home-manager
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
