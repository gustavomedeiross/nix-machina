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
      # TODO: remove commit when emacsql error with org-roam is fixed
      url = "github:nix-community/emacs-overlay/ed670c7246dd4bfd24e50939eb5d9bcaa95e638b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Remove once this is done: https://github.com/nix-community/home-manager/issues/1341
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
      emacs-overlay,
      mac-app-util,
    }:
    let
      overlays = [
        emacs-overlay.overlay
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
