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

  programs.opam = {
    enable = true;
    enableZshIntegration = true;
  };

  # TODO: home.sessionPath is broken on nix-darwin + zsh — nix-darwin's
  # /etc/zshenv hard-resets PATH after hm-session-vars.sh sets it, and the
  # guard prevents it from running again. These entries have no effect.
  # Use shell.nix initContent instead.
  # See: https://github.com/nix-community/home-manager/issues/3417
  #      https://github.com/nix-community/home-manager/issues/2991
  home.sessionPath = [
    # Add local scripts to PATH
    "$HOME/.local/bin"
    # Cargo binaries
    "$HOME/.cargo/bin"
    # npm global packages
    "$HOME/.npm-packages/bin"
  ];

  # TODO: find out a cleaner way to do that
  home.file = {
    # zelda sounds
    ".local/share/sounds/zelda/cucco.wav".source = ./sounds/zelda/cucco.wav;
    ".local/share/sounds/zelda/crystal.wav".source = ./sounds/zelda/crystal.wav;
    ".local/share/sounds/zelda/fairy.wav".source = ./sounds/zelda/fairy.wav;
    ".local/share/sounds/zelda/flute-1.wav".source = ./sounds/zelda/flute-1.wav;
    ".local/share/sounds/zelda/low-hp.wav".source = ./sounds/zelda/low-hp.wav;
    ".local/share/sounds/zelda/link-falls.wav".source = ./sounds/zelda/link-falls.wav;
    ".local/share/sounds/zelda/secret.wav".source = ./sounds/zelda/secret.wav;
    ".local/share/sounds/zelda/heart-container-1.wav".source = ./sounds/zelda/heart-container-1.wav;
    ".local/share/sounds/zelda/item-get-1.wav".source = ./sounds/zelda/item-get-1.wav;
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

  home.shellAliases = {
    start-fluidsynth = "fluidsynth -a coreaudio -m coremidi ${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
    claude-personal = "CLAUDE_CONFIG_DIR=$HOME/.claude-personal command claude";
    claude-bluecode = "CLAUDE_CONFIG_DIR=$HOME/.claude-bluecode command claude";
  };
}
