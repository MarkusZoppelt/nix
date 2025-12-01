{
  pkgs,
  lib,
  ...
}:
{
  home = {
    stateVersion = "24.11";

    # remove after upgrading to 25.11
    enableNixpkgsReleaseCheck = false;

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      NPM_CONFIG_PREFIX = "$HOME/.npm";
    };

    sessionPath = [
      "$HOME/.cargo/bin"
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

    packages =
      with pkgs;
      [
        cargo
        fd
        lazydocker
        luarocks
        nodejs
        restic
        rust-analyzer
        tree
        unzip
        uv
        wget
        zip
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        _1password-cli
        _1password-gui
        clang
        signal-desktop
        syncthing
      ];
  };

  imports = [
    ./programs/btop.nix
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/go.nix
    ./programs/lazygit.nix
    ./programs/neovim.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
  ];

  programs = {
    fd.enable = true;
    jq.enable = true;
    obsidian.enable = true;
    ripgrep.enable = true;
  };

  services = lib.optionalAttrs pkgs.stdenv.isLinux {
    syncthing = {
      enable = true;
    };
  };
}
