{ pkgs, ... }:
{
  programs.zsh = {
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
    initContent =
      let
        linuxInit = pkgs.lib.optionalString pkgs.stdenv.isLinux ''
          # gnome-keyring clobbers SSH_AUTH_SOCK at login. Override it back to
          # the 1Password agent, unless a forwarded agent is already in place
          # (forwarded sockets live under /tmp, not /run).
          if [[ "$SSH_AUTH_SOCK" != /tmp/* ]]; then
            export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
          fi
        '';
        darwinInit = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
          # On Darwin, use 1Password as a fallback so that a forwarded agent
          # socket (set by sshd via `ssh -A`) takes precedence.
          export SSH_AUTH_SOCK="''${SSH_AUTH_SOCK:-$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock}"
        '';
      in
      ''
        ${builtins.readFile ./zshrc}
      '' + linuxInit + darwinInit;
  };
}
