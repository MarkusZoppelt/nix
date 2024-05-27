{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    azure-cli
    bazelisk
    bazel-buildtools
    cmake
    lcov
    llvm
    rclone
  ];

  networking.hostName = "G-Man";
}
