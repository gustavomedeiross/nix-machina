{ pkgs }:

with pkgs; [
  alacritty
  awscli2
  coreutils
  docker
  docker-compose
  emacs
  fzf
  gcc
  gh # github
  google-cloud-sdk
  home-manager
  htop
  jq

  nodePackages.npm
  nodejs
  openssh
  pandoc
  postgresql
  ripgrep
  tmux
  unrar
  unzip
  wget
  zip
]
