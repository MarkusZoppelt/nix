{
  pkgs,
  lib,
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
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      _1password-cli
      _1password-gui
      signal-desktop
      syncthing
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
      delta.enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = lib.optionals pkgs.stdenv.isDarwin [
        "~/.orbstack/ssh/config"
      ];
      matchBlocks = {
        "100.* *.ts.net" = {
          forwardAgent = true;
        };
        "*" = {};
      };
      extraConfig =
        let
          identityAgent = if pkgs.stdenv.isDarwin
            then "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            else "~/.1password/agent.sock";
        in ''
          IdentityAgent "${identityAgent}"
        '';
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
        ${builtins.readFile ./zshrc}
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        cmp-buffer
        cmp-nvim-lsp
        harpoon
        lazygit-nvim
        mason-lspconfig-nvim
        mason-nvim
        noice-nvim
        nui-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-notify
        nvim-treesitter.withAllGrammars
        nvim-treesitter-context
        plenary-nvim
        telescope-nvim
        tokyonight-nvim
        trouble-nvim
        vim-fugitive
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./nvim/options.lua}
        ${builtins.readFile ./nvim/keymaps.lua}
        ${builtins.readFile ./nvim/plugins/mason-lsp.lua}
        ${builtins.readFile ./nvim/plugins/cmp.lua}
        ${builtins.readFile ./nvim/plugins/telescope.lua}
        ${builtins.readFile ./nvim/plugins/harpoon.lua}
        ${builtins.readFile ./nvim/plugins/treesitter.lua}
        ${builtins.readFile ./nvim/plugins/trouble.lua}
        ${builtins.readFile ./nvim/plugins/lazygit.lua}
        ${builtins.readFile ./nvim/plugins/noice.lua}
        ${builtins.readFile ./nvim/theme.lua}
      '';
    };

    lazygit = {
      enable = true;
      settings = {
        git.autoFetch = false;
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
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
      extraConfig = builtins.readFile ./tmux.conf;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    go = {
      enable = true;
      env.GOPATH = [ "code/go" ];
    };

    fd.enable = true;
    jq.enable = true;
    obsidian.enable = true;
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

  services = lib.optionalAttrs pkgs.stdenv.isLinux {
    syncthing = {
      enable = true;
    };
  };
}
