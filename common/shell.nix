{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
    };

    initExtra = ''
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#877C70"

    # art
    PROMPT="%{$fg_bold[red]%}[ %{$fg_bold[yellow]%}%n% %{$fg_bold[green]%}@%{$fg_bold[blue]%}%m%  %{$fg_bold[red]%}]"
    # dark
    # PROMPT="%{$fg_bold[yellow]%}[ %{$fg_bold[blue]%}%n% %{$fg_bold[yellow]%}@%{$fg_bold[magenta]%}%m%  %{$fg_bold[yellow]%}]"

    # path + git
    PROMPT+=' %{$fg[cyan]%}% $(shrink_path -f) %{$reset_color%} $(git_prompt_info)'

    # vi mode
    bindkey -v
    bindkey -M viins 'jk' vi-cmd-mode

    # alias for managing my dotfiles with a git bare repository
    alias dotfiles="/usr/bin/git --git-dir=/$HOME/.dotfiles/ --work-tree=/$HOME"

    # Add local scripts to PATH
    export PATH="$HOME/.local/bin:$PATH"

    # Mactex
    export PATH="/Library/TeX/texbin:$PATH"

    # Load computer specific configurations
    source "$HOME/.local/zsh.sh"

    # https://codeberg.org/akib/emacs-eat
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"
                              '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" "macos" "command-not-found" "vi-mode" "shrink-path" ];
      theme = "robbyrussell";
    };

    plugins = with pkgs; [
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
        };
        file = "zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.34.0";
          sha256 = "0jjgvzj3v31yibjmq50s80s3sqi4d91yin45pvn3fpnihcrinam9";
        };
        file = "zsh-completions.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
