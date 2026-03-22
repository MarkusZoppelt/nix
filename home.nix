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
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/Documents/go/bin"
      "$HOME/Documents/nix/bin"
    ];

    shellAliases = {
      ls = "ls -F --color=always";
      ll = "ls -lh";
      lg = "lazygit";
      vim = "nvim";
    };

    packages =
      with pkgs;
      [
        cargo
        claude-code
        clippy
        dua
        duf
        fd
        lazydocker
        luarocks
        nil
        nodejs
        restic
        rust-analyzer
        rustc
        rustfmt
        tree
        unzip
        uv
        wget
        zip
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        _1password-cli
        clang
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
    nh = {
      enable = true;
      flake = "$HOME/Documents/nix";
    };
    obsidian.enable = true;
    ripgrep.enable = true;
  };

  services = lib.optionalAttrs pkgs.stdenv.isLinux {
    syncthing = {
      enable = true;
    };
  };
}
