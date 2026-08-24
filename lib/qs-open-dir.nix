{ pkgs }:
pkgs.writeShellApplication {
  name = "qs-open-dir";
  runtimeInputs = with pkgs; [
    coreutils
    xdg-utils
  ];
  text = ''
    path=''${1-}
    [[ $path == /* && $path != *://* && $path != *$'\n'* ]] || exit 1
    real=$(realpath -e -- "$path")
    [[ $real == "$path" && -d $path && ! -L $path ]] || exit 1
    exec xdg-open "$path"
  '';
}
