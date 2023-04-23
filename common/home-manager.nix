{ config, pkgs, lib, ... }:

{
  imports = [./shell.nix];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
