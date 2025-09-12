{
  pkgs,
  ...
}:
{
  home = {
    stateVersion = "24.11";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      NPM_CONFIG_PREFIX = "$HOME/.npm";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/code/go/bin"
    ];

    shellAliases = {
      ls = "ls -F --color=always";
      ll = "ls -l";
      lg = "lazygit";
      vim = "nvim";
    };

    packages = with pkgs; [
      _1password-cli
      lazydocker
      luarocks
      nodejs
      restic
      rustup
      sd
      tree
      unzip
      wget
      zip
    ];

  };

  programs = {
    git = {
      enable = true;
      userName = "Markus Zoppelt";
      userEmail = "markus@zoppelt.net";
      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.editor = "nvim";
        core.askPass = ""; # needs to be empty to use terminal for ask pass
        github.user = "MarkusZoppelt";
        push.default = "simple";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
      ignores = [
        "result"
        ".idea"
        "*~"
        "*.swp"
        ".DS_Store"
        ".Spotlight-V100"
        ".Trashes"
        ".vimrc.local"
        ".vim/.netrwhist"
        ".vim/spell/"
        ".vim/colors/"
        ".vscode/"
        "dump.rdb"
        ".opencode/"
        ".direnv"
      ];
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      history = {
        size = 9999999;
        save = 9999999;
        share = true;
        extended = true;
      };

      initContent = ''
        zstyle ':completion:*' menu select=1

        bindkey -s '^a' "tmux a\n"
        bindkey -s '^f' "tmux-sessionizer\n"
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };


    lazygit = {
      enable = true;
      settings = {
        git.autoFetch = false;
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      extraConfig = ''
        unbind C-b
        set -g prefix C-a
        bind C-a send-prefix
        bind t split-window -f -l 15 -c "#{pane_current_path}"
        bind T split-window -h -f -p 35 -c "#{pane_current_path}"
        set-option -g default-terminal "screen-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"
        set -g history-limit 9999999
        set -g mouse on
        setw -g mouse on
        set -sg escape-time 0
        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on
        set -g status-style fg="#3b4261",bg="#16161e"
        setw -g window-status-current-style bg=default,fg="#7aa2f7"
        set-option -g focus-events on
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    go = {
      enable = true;
      goPath = "code/go";
    };

    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$hostname$directory$git_branch$git_status$character";

        directory = {
          style = "fg:#769ff0 bold";
          truncation_length = 3;
        };

        git_branch = {
          symbol = "";
          format = "on [[$branch](purple)]($style) ";
        };

        git_status = {
          format = "[[($all_status$ahead_behind )](fg:#769ff0)]($style)";
        };

        hostname = {
          ssh_only = true;
          format = "[@$hostname](bold green) ";
        };
      };
    };
  };
}
