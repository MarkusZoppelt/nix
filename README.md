# Nix(OS) config files

## Setup

### NixOS

    cp /etc/nixos/hardware-configuration.nix ./hosts/NixOS/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#NixOS

### Orbstack (NixOS VM):

Install [Orbstack](https://orbstack.dev) and create a NixOS
[machine](https://docs.orbstack.dev/machines), then install as usual:

    sudo nixos-rebuild switch --flake .#Orbstack

### Darwin

Unlike NixOS, `nix-darwin` does not have an installer, you can just run
`darwin-rebuild switch` to install nix-darwin. As `darwin-rebuild` won't be
installed in your `PATH` yet, you can use the following command:

    nix run nix-darwin -- switch --flake .#Darwin

After installing, you can run darwin-rebuild to apply changes to your system:

    darwin-rebuild switch --flake .#Darwin

### Linux (home-manager)

    nix run nixpkgs#home-manager -- switch --flake .#Linux
