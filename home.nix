{
  pkgs,
  lib,
  ...
}:
{
  home = {
    stateVersion = "26.05";

    file.".local/bin/power-menu" = {
      source = ./bin/power-menu;
      executable = true;
    };

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      NPM_CONFIG_PREFIX = "$HOME/.npm";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/Documents/go/bin"
      "$HOME/Documents/nix/bin"
    ];

    shellAliases = {
      ls = "ls -F --color=always";
      ll = "ls -l --color=always";
      lg = "lazygit";
    };

    packages = with pkgs; [
      _1password-cli
      dust
      gh
      gopls
      herdr
      lazydocker
      llm-agents.opencode
      nil
      nodejs
      restic
      typescript-language-server
    ];
  };

  imports = [
    ./programs/btop.nix
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/go.nix
    ./programs/jujutsu.nix
    ./programs/jjui.nix
    ./programs/lazygit.nix
    ./programs/ncspot.nix
    ./programs/neovim.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
  ];

  programs = {
    fd.enable = true;
    hunk.enable = true;
    jjui.enable = true;
    jq.enable = true;
    nh = {
      enable = true;
      flake = "$HOME/Documents/nix";
    };
    ripgrep.enable = true;
  };

  services = lib.optionalAttrs pkgs.stdenv.isLinux {
    syncthing = {
      enable = true;
    };
  };
}
