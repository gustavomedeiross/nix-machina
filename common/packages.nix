{ pkgs }:

with pkgs; [
  alacritty
  aws-vault
  chamber
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
  tailscale
  tmux
  unrar
  unzip
  vscode
  wget
  zip
]
