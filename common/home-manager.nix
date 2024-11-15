{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./shell.nix ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # TODO: find out a cleaner way to do that
  home.file = {
    # emacs
    ".emacs.d/early-init.el".source = ./emacs/early-init.el;
    ".emacs.d/site-lisp/lilypond-font-lock.el".source = ./emacs/site-lisp/lilypond-font-lock.el;
    ".emacs.d/site-lisp/lilypond-indent.el".source = ./emacs/site-lisp/lilypond-indent.el;
    ".emacs.d/site-lisp/lilypond-init.el".source = ./emacs/site-lisp/lilypond-init.el;
    ".emacs.d/site-lisp/lilypond-mode.el".source = ./emacs/site-lisp/lilypond-mode.el;
    ".emacs.d/site-lisp/lilypond-what-beat.el".source = ./emacs/site-lisp/lilypond-what-beat.el;
    ".emacs.d/site-lisp/lilypond-words.el".source = ./emacs/site-lisp/lilypond-words.el;
    # ocaml
    ".ocamlinit" = {
      text = ''
      #use "topfind";;
      #require "lwt";;
      #require "ptime";;
      #require "uuidm";;
      '';
    };
  };
}
