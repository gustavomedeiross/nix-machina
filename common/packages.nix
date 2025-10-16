{ pkgs }:

let
  emacs = import ./emacs.nix { inherit pkgs; };
  ocamlpkgs = import ./ocaml.nix { inherit pkgs; };
  rustpkgs = import ./rust.nix { inherit pkgs; };
  fluidsynth = import ./fluidsynth.nix { inherit pkgs; };
  git-remote-dropbox = import ./git-remote-dropbox.nix { inherit pkgs; };
in
with pkgs; ocamlpkgs ++ rustpkgs ++ fluidsynth ++ [
  alacritty
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
  go-task
  graphviz
  haproxy
  home-manager
  hledger
  htop
  imagemagick
  inkscape
  jq
  libtool
  nixfmt-rfc-style
  nodejs
  openssh
  pandoc
  postgresql
  rclone
  ripgrep
  tailscale
  tailwindcss
  tmux
  unrar
  unzip
  vscode
  wget
  wireguard-tools
  wireguard-go
  zip
]
