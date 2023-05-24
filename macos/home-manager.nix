{ config, pkgs, lib, ... }:

let
  common-hm-config = import ../common/home-manager.nix { config = config; pkgs = pkgs; lib = lib; };
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
  homebrew.casks = pkgs.callPackage ./casks.nix {};
  homebrew.masApps = {
    "1password" = 1333542190;
    "tailscale" = 1475387142;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.gustavo = { pkgs, lib, ... }: lib.recursiveUpdate common-hm-config {
      programs = {};
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.stateVersion = "22.11";

      targets.darwin.keybindings = {
        "^&#xF702;" = "moveWordLeft:";
        "^&#xF703;" = "moveWordRight:";
        "^$&#xF702;" = "moveWordLeftAndModifySelection:";
        "^$&#xF703;" = "moveWordRightAndModifySelection:";
      };

      # Remove once this is done: https://github.com/nix-community/home-manager/issues/1341

      # This is only required because we're linking manually
      disabledModules = [ "targets/darwin/linkapps.nix" ];

      home.activation = lib.mkIf pkgs.stdenv.isDarwin {
        copyApplications = let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            # TODO: change
            paths = pkgs.callPackage ./packages.nix {};
            pathsToLink = "/Applications";
          };
        in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -d "$baseDir" ]; then
            rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '';
      };
    };
  };
}
