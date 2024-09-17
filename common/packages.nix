{ pkgs }:

let
  emacs = import ./emacs.nix { inherit pkgs; };
in
with pkgs; [
  alacritty
  awscli
  aws-vault
  chamber
  cmake
  coreutils
  docker
  docker-compose
  emacs
  fira-code
  fzf
  gcc
  gh
  google-cloud-sdk
  graphviz
  haproxy
  home-manager
  htop
  imagemagick
  jq
  libgccjit
  libtool
  nodePackages.npm
  nodejs
  openssh
  pandoc
  postgresql
  ripgrep
  tailscale
  tmux
  unrar
  unzip
  vscode
  wget
  wireguard-tools
  wireguard-go
  zip
]
