{ config, pkgs, lib, ... }:

let
  shell = import ./shell.nix { config = config; pkgs = pkgs; lib = lib; };
in

shell // {
  direnv.enable = true;
  direnv.nix-direnv.enable = true;
}
