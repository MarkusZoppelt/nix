# Nix(OS) config files

Cross-platform Nix configuration for NixOS and macOS (Darwin).

## Setup

### NixOS

    ./hosts/NixOS/label-partitions.sh
    sudo nixos-rebuild switch --flake .#NixOS

See [SECURITY.md](SECURITY.md) for Secure Boot and TPM2 setup.

### Darwin (macOS)

    nix run nix-darwin -- switch --flake .#Darwin
