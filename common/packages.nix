{ pkgs, ... }:

let
  emacs = import ./emacs.nix { inherit pkgs; };
  ocamlpkgs = import ./ocaml.nix { inherit pkgs; };
  rustpkgs = import ./rust.nix { inherit pkgs; };
  fluidsynth = import ./fluidsynth.nix { inherit pkgs; };
  git-remote-dropbox = import ./git-remote-dropbox.nix { inherit pkgs; };
in
with pkgs; ocamlpkgs ++ rustpkgs ++ fluidsynth ++ [
  agenix
  asdf-vm
  awscli
  aws-vault
  borgbackup
  chamber
  cmake
  clang-tools
  coreutils
  docker
  docker-compose
  emacs
  fira-code
  fzf
  gh
  git-remote-dropbox
  google-cloud-sdk
  gnupg
  go-task
  graphviz
  haproxy
  home-manager
  hledger
  htop
  imagemagick
  inkscape
  jq
  just
  libtool
  mermaid-cli
  nixfmt-rfc-style
  nodejs
  openssh
  pandoc
  poppler_utils
  postgresql
  rclone
  ripgrep
  texliveMedium
  tailscale
  tailwindcss
  tmux
  unison-ucm
  unrar
  unzip
  vscode
  wget
  wireguard-tools
  wireguard-go
  zip
]
