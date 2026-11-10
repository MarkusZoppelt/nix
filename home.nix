{
  config,
  direnv-instant,
  pkgs,
  lib,
  llm-agents,
  ...
}:
let
  llm = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home = {
    stateVersion = "26.05";

    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "nvim";
    };

    packages =
      with pkgs;
      [
        _1password-cli
        duf
        lazydocker
        nil
        restic
        tea
      ]
      ++ [
        llm.claude-code
        llm.hunk
        llm.opencode2
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        (import ./lib/agent-usage.nix { inherit pkgs; })
      ];
  };

  imports = [
    direnv-instant.homeModules.direnv-instant
    ./programs/btop.nix
    ./programs/direnv.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jjui.nix
    ./programs/jujutsu.nix
    ./programs/ncspot.nix
    ./programs/neovim.nix
    ./programs/nushell.nix
    ./programs/ssh.nix
    ./programs/starship.nix
  ];

  programs = {
    direnv-instant.enable = true;
    fd.enable = true;
    fzf.enable = true;
    # gh doubles as git's credential helper for github.com, so HTTPS
    # pushes/pulls work over remote sessions without 1Password.
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        aliases.co = "pr checkout";
      };
    };
    jq.enable = true;
    nh = {
      enable = true;
      # Nushell session variables are JSON, so "$HOME/..." is not expanded
      # and nh looks for a relative path that does not exist.
      flake = "${config.home.homeDirectory}/Documents/nix";
    };
    ripgrep.enable = true;
  };
}
