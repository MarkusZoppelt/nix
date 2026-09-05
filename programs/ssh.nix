{
  pkgs,
  lib,
  config,
  ...
}:
let
  sock =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  # Use 1Password as the SSH agent in every shell, but keep a forwarded
  # agent when this session is over SSH (home-manager 26.05 sshAuthSock).
  sshAuthSock.initialization = {
    bash = ''export SSH_AUTH_SOCK="${sock}"'';
    nushell = ''$env.SSH_AUTH_SOCK = "${sock}"'';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optionals pkgs.stdenv.isDarwin [
      "~/.orbstack/ssh/config"
    ];
    settings = {
      "100.* *.ts.net alyx gordon" = {
        ForwardAgent = true;
      };
    };
  };
}
