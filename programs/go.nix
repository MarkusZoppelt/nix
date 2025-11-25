{ pkgs, ... }:

{
  programs.go = {
    enable = true;
    env.GOPATH = if pkgs.stdenv.isDarwin then [ "/Users/mz/code/go" ] else [ "/home/mz/code/go" ];
  };
}
