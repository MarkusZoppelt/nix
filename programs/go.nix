{ pkgs, ... }:

{
  programs.go = {
    enable = true;
    env.GOPATH = if pkgs.stdenv.isDarwin then [ "/Users/mz/Documents/go" ] else [ "/home/mz/Documents/go" ];
  };
}
