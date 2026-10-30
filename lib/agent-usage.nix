{ pkgs }:
pkgs.writeShellApplication {
  name = "agent-usage";
  runtimeInputs = with pkgs; [
    curl
    findutils
    jq
    sqlite
    util-linux
  ];
  text = builtins.readFile ../bin/agent-usage;
}
