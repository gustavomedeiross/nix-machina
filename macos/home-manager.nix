{ config, pkgs, lib, ... }:

let
  common-programs = import ../common/home-manager.nix { config = config; pkgs = pkgs; lib = lib; }; in
{
  imports = [
    <home-manager/nix-darwin>
  ];

  users.users.gustavo = {
    name = "gustavo";
    home = "/Users/gustavo";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # Homebrew is used to install impure software only (Mac Apps)
  homebrew.enable = true;
  homebrew.onActivation = {
	  autoUpdate = true;
	  cleanup = "zap";
	  upgrade = true;
  };
  homebrew.brewPrefix = "/opt/homebrew/bin";
  homebrew.casks = pkgs.callPackage ./casks.nix {};
  homebrew.masApps = {
    "1password" = 1333542190;
    "tailscale" = 1475387142;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.gustavo = { pkgs, lib, ... }: {
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.stateVersion = "22.11";
      programs = common-programs // {};
    };
  };
}
