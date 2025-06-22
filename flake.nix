{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin }: {
    nixosConfigurations = {
      NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/common.nix
          ./hosts/NixOS/configuration.nix
        ];
      };
      NixOS-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./nixos/common.nix
          ./hosts/NixOS-aarch64/configuration.nix
        ];
      };
      Orbstack = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/Orbstack/configuration.nix
        ];
      };
    };

    darwinConfigurations = {
      Darwin = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin/common.nix ];
      };
    };
  };
}
