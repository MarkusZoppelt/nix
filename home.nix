{
  pkgs,
  lib,
  ...
}:
{
  home = {
    stateVersion = "26.05";

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };

    packages =
      with pkgs;
      [
        _1password-cli
        duf
        gh
        gopls
        lazydocker
        llm-agents.herdr
        llm-agents.hunk
        llm-agents.opencode2
        nil
        nodejs
        restic
        sqlite
        typescript-language-server
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        (import ./lib/agent-usage.nix { inherit pkgs; })
      ];
  };

  imports = [
    ./programs/btop.nix
    ./programs/direnv.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/go.nix
    ./programs/jjui.nix
    ./programs/jujutsu.nix
    ./programs/ncspot.nix
    ./programs/neovim.nix
    ./programs/nushell.nix
    ./programs/ssh.nix
    ./programs/starship.nix
  ];

  programs = {
    fd.enable = true;
    fzf.enable = true;
    jq.enable = true;
    nh = {
      enable = true;
      package = pkgs.unstable.nh;
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
