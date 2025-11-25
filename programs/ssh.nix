{ pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optionals pkgs.stdenv.isDarwin [
      "~/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "100.* *.ts.net" = {
        forwardAgent = true;
      };
      "*" = { };
    };
    extraConfig =
      let
        identityAgent =
          if pkgs.stdenv.isDarwin then
            "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "~/.1password/agent.sock";
      in
      ''
        IdentityAgent "${identityAgent}"
      '';
  };
}
