{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  common-hm-config = import ../common/home-manager.nix {
    config = config;
    pkgs = pkgs;
    lib = lib;
  };
in
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
  homebrew.brews = pkgs.callPackage ./brews.nix { };
  homebrew.casks = pkgs.callPackage ./casks.nix { };
  homebrew.masApps = { };

  home-manager = {
    useGlobalPkgs = true;
    users.gustavo =
      { pkgs, lib, ... }:
      lib.recursiveUpdate common-hm-config {
        programs = { };
        home.enableNixpkgsReleaseCheck = false;
        home.packages = pkgs.callPackage ./packages.nix { };
        home.stateVersion = "22.11";

        targets.darwin.keybindings = {
          "^&#xF702;" = "moveWordLeft:";
          "^&#xF703;" = "moveWordRight:";
          "^$&#xF702;" = "moveWordLeftAndModifySelection:";
          "^$&#xF703;" = "moveWordRightAndModifySelection:";
        };
      };

    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };
}
