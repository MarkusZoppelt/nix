# Turn an attrset into a Quickshell Theme.qml singleton.
{ lib }:
let
  capitalize =
    s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (lib.stringLength s) s;
  camelCase =
    name:
    let
      parts = lib.splitString "_" name;
    in
    lib.head parts + lib.concatMapStrings capitalize (lib.drop 1 parts);
  emit =
    name: value:
    if builtins.isString value && lib.hasPrefix "#" value then
      "  readonly property color ${name}: \"${value}\""
    else if builtins.isString value then
      "  readonly property string ${name}: \"${value}\""
    else if builtins.isInt value then
      "  readonly property int ${name}: ${toString value}"
    else if builtins.isFloat value then
      "  readonly property real ${name}: ${toString value}"
    else
      throw "unsupported theme value ${name}";
in
{
  singleton =
    attrs:
    lib.concatStringsSep "\n" (
      [
        "pragma Singleton"
        "import QtQuick"
        "import Quickshell"
        ""
        "Singleton {"
      ]
      ++ lib.mapAttrsToList (name: value: emit (camelCase name) value) attrs
      ++ [ "}" ]
    );
}
