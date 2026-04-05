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
      { pkgs, lib, config, ... }:
      let
        backup = import ../common/backup.nix { inherit pkgs; };
      in
      lib.recursiveUpdate common-hm-config {
        # TODO: uncomment when vault is set up
        # launchd.agents.vault-backup = {
        #   enable = true;
        #   config = {
        #     ProgramArguments = [ "${backup.launchdWrapper}/bin/vault-launchd" ];
        #     StartInterval = 14400; # every 4 hours
        #     StandardOutPath = "/Users/gustavo/.local/share/vault-backup/launchd-stdout.log";
        #     StandardErrorPath = "/Users/gustavo/.local/share/vault-backup/launchd-stderr.log";
        #   };
        # };
        age = {
          identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
          secrets.anthropic-api-key.file = ../secrets/anthropic-api-key.age;
          secrets.borg-passphrase.file = ../secrets/borg-passphrase.age;
          secrets.email.file = ../secrets/email.age;
          secrets.msmtp-config.file = ../secrets/msmtp-config.age;
        };
        programs = {
          alacritty = {
            enable = true;
            settings = {
              window.resize_increments = false;
            };
          };
        };
        home.enableNixpkgsReleaseCheck = false;
        home.packages = (pkgs.callPackage ./packages.nix { }) ++ [ backup.backupScript ];
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
      inputs.agenix.homeManagerModules.default
    ];
  };
}
