{ pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optionals pkgs.stdenv.isDarwin [
      "~/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "100.* *.ts.net alyx gordon" = {
        forwardAgent = true;
      };
      "*" = { };
    };

  };
}
