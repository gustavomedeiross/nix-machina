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
    ".emacs.d/site-lisp/lilypond-font-lock.el".source = ./emacs/site-lisp/lilypond-font-lock.el;
    ".emacs.d/site-lisp/lilypond-indent.el".source = ./emacs/site-lisp/lilypond-indent.el;
    ".emacs.d/site-lisp/lilypond-init.el".source = ./emacs/site-lisp/lilypond-init.el;
    ".emacs.d/site-lisp/lilypond-mode.el".source = ./emacs/site-lisp/lilypond-mode.el;
    ".emacs.d/site-lisp/lilypond-what-beat.el".source = ./emacs/site-lisp/lilypond-what-beat.el;
    ".emacs.d/site-lisp/lilypond-words.el".source = ./emacs/site-lisp/lilypond-words.el;
  };
}
