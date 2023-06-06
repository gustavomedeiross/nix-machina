{ pkgs }:

with pkgs; [
  alacritty
  aws-vault
  coreutils
  devenv
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
  vscode
  wget
  zip
]
