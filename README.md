# Nix(OS) config files

Cross-platform Nix configuration for NixOS and macOS (Darwin).

## Setup

### NixOS

Replace the dummy hardware config with your real one:

    cp /etc/nixos/hardware-configuration.nix ./hosts/NixOS/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#NixOS

For aarch64 systems:

    cp /etc/nixos/hardware-configuration.nix ./hosts/NixOS-aarch64/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#NixOS-aarch64

### Darwin (macOS)

Initial setup:

    nix run nix-darwin -- switch --flake .#Darwin

After that, use:

    darwin-rebuild switch --flake .#Darwin
