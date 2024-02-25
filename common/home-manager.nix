{ config, pkgs, lib, ... }:

{
  imports = [./shell.nix];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file = {
    ".emacs.d/early-init.el".source = ./emacs/early-init.el;
    ".emacs.d/init.el".source = ./emacs/init.el;
  };
}
