{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    nixosConfigurations = {
      NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./shared/nixos/common-config.nix
          ./hosts/NixOS/configuration.nix
        ];
      };
      NixOS-headless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./shared/nixos/common-config.nix
          ./hosts/NixOS-headless/configuration.nix
        ];
      };
      Orbstack = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/Orbstack/configuration.nix ];
      };
    };

    darwinConfigurations = {
      Darwin = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./shared/darwin/common-config.nix ];
      };
    };

    homeConfigurations = {
      Linux = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./shared/linux/home.nix ];
      };
      Linux-aarch64 = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [ ./shared/linux/home.nix ];
      };
    };
  };
}
