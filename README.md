# Nix(OS) config files

Cross-platform Nix configuration for NixOS, macOS (Darwin), and Linux with home-manager.

## Setup

### NixOS

Replace the dummy hardware config with your real one:

    cp /etc/nixos/hardware-configuration.nix ./hosts/NixOS/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#NixOS

For headless systems:

    cp /etc/nixos/hardware-configuration.nix ./hosts/NixOS-headless/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#NixOS-headless

### Orbstack (NixOS VM)

Install [Orbstack](https://orbstack.dev) and create a NixOS [machine](https://docs.orbstack.dev/machines):

    sudo nixos-rebuild switch --flake .#Orbstack

### Darwin (macOS)

Initial setup:

    nix run nix-darwin -- switch --flake .#Darwin

After that, use:

    darwin-rebuild switch --flake .#Darwin

### Linux (home-manager)

For x86_64 systems:

    nix run nixpkgs#home-manager -- switch --flake .#Linux

For aarch64 systems:

    nix run nixpkgs#home-manager -- switch --flake .#Linux-aarch64

