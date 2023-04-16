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
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {

    darwinConfigurations = {
      "macbook" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./macos
        ];
        inputs = { inherit darwin home-manager nixpkgs; };
      };
    };
  };
}
