{ pkgs }:

let
  emacs = import ./emacs.nix { inherit pkgs; };
  ocamlpkgs = import ./ocaml.nix { inherit pkgs; };
in
with pkgs; ocamlpkgs ++ [
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
  google-cloud-sdk
  graphviz
  haproxy
  home-manager
  htop
  imagemagick
  jq
  libtool
  nixfmt-rfc-style
  nodePackages.npm
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
