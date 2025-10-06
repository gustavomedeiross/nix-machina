{ pkgs, ... }:

let
  # not yet available in MELPA: https://github.com/copilot-emacs/copilot.el/issues/120
  copilot-el =
    let
      rev = "edf517a57f539eb41eaa2f92c6752538f3a62b72";
    in
    pkgs.emacsPackages.trivialBuild {
      pname = "copilot";
      version = rev;

      src = pkgs.fetchFromGitHub {
        owner = "copilot-emacs";
        repo = "copilot.el";
        inherit rev;
        sha256 = "sha256-53BGX2llkrM5mDmFSVe+O/Vo4F2gDJTFh/4TqBuQme8=";
      };

      packageRequires =
        with pkgs;
        with emacsPackages;
        [
          dash
          editorconfig
          f
          s
        ];

      meta = {
        description = "An unofficial Copilot plugin for Emacs";
        license = pkgs.lib.licenses.mit;
      };
    };
in

(pkgs.emacsWithPackagesFromUsePackage {
  # Your Emacs config file. Org mode babel files are also
  # supported.
  # NB: Config files cannot contain unicode characters, since
  #     they're being parsed in nix, which lacks unicode
  #     support.
  config = ./emacs/config.org;

  # Whether to include your config as a default init file.
  # If being bool, the value of config is used.
  # Its value can also be a derivation like this if you want to do some
  # substitution:
  #   defaultInitFile = pkgs.substituteAll {
  #     name = "default.el";
  #     src = ./emacs.el;
  #     inherit (config.xdg) configHome dataHome;
  #   };
  defaultInitFile = true;

  # Package is optional, defaults to pkgs.emacs
  package = pkgs.emacs-unstable;

  # By default emacsWithPackagesFromUsePackage will only pull in
  # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
  # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
  # and pulls in all use-package references not explicitly disabled via
  # `:ensure nil` or `:disabled`.
  # Note that this is NOT recommended unless you've actually set
  # `use-package-always-ensure` to `t` in your config.
  alwaysEnsure = true;

  # For Org mode babel files, by default only code blocks with
  # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
  # will include all code blocks missing the `:tangle` argument,
  # defaulting it to `yes`.
  # Note that this is NOT recommended unless you have something like
  # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
  # which defaults `:tangle` to `yes`.
  alwaysTangle = true;

  # Optionally provide extra packages not in the configuration file.
  extraEmacsPackages = epkgs: [
    epkgs.use-package
    epkgs.diminish
    epkgs.general
    epkgs.vterm
    # copilot-el
  ];

  # Optionally override derivations.
  # override = final: prev: {
  #   weechat = prev.melpaPackages.weechat.overrideAttrs(old: {
  #     patches = [ ./weechat-el.patch ];
  #   });
  # };
})
