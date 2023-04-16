# Nix Machina

Nix configuration for my computer

# Bootstrap MacOS Computer

## 1. Install Nix

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
```

```sh
nix-channel --update
```

## 2. Install Home-Manager

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
```

```sh
nix-channel --update
```

## 3. Install Xcode CLI tools

```sh
xcode-select --install
```

## 4. Install Homebrew and add it to your shell env

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
eval "$(/opt/homebrew/bin/brew shellenv)
```

```sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.local/zsh.sh # or ~/.zshrc if you're not using my dotfiles
```

## 5. Install nix-darwin

```sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
```

```sh
./result/bin/darwin-installer
```

## 6. Download this repo and build the environment

```sh
git clone git@github.com:gustavomdeiros/nix-machina.git
```

```sh
./bin/build.sh
```

# Update deps

## 1. Download latest updates

```sh
nix flake update
```

## 2. Build the environment

```sh
./bin/build.sh
```
