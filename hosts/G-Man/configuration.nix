{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    azure-cli
    bazel
    bazelisk
    bazel-buildtools
    cmake
    lcov
    llvm
    rclone
  ];

  networking.hostName = "G-Man";
}
