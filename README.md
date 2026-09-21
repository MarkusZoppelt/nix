# Nix(OS) config files

Cross-platform Nix configuration for NixOS and macOS (Darwin).

## Setup

### NixOS

    ./hosts/NixOS/label-partitions.sh
    sudo nixos-rebuild switch --flake .#Gordon

See [SECURITY.md](SECURITY.md) for Secure Boot and TPM2 setup.

### Darwin (macOS)

    nix run nix-darwin -- switch --flake .#Alyx

### Shared cache (Alyx → Gordon)

Alyx serves `/nix/store` over Tailscale via Harmonia. Gordon substitutes from
`http://alyx:5001` (sources/FODs overlap; Linux closures after a copy).

    # Gordon, after a rebuild:
    nix-copy-alyx
