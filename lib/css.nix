{ lib, colors }:
lib.concatStringsSep "\n" (
  lib.mapAttrsToList (name: value: "@define-color ${name} ${value};") colors
)
