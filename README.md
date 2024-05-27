# Nix(OS) config files

## Setup

First, install nix via [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer).

On macOS, install nix-darwin

    nix run nix-darwin -- switch --flake .


## Build system from flakes:

On Darwin:

    darwin-rebuild switch --flake .#<host>

On NixOS:

    cp /etc/nixos/hardware-configuration.nix ./hosts/<host>/hardware-configuration.nix
    sudo nixos-rebuild switch --flake .#<host>

