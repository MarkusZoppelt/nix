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

  outputs = { self, nixpkgs, darwin, home-manager }@inputs: {
    nixosConfigurations = {
      Gordon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = 
        [
          ./shared/common-config.nix
          ./shared/nixos/common-config.nix
          ./hosts/Gordon/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mz = import ./shared/home.nix;
          }
        ];
      };
    };

    darwinConfigurations = {
      Alyx = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = 
        [ 
          ./shared/common-config.nix
          ./shared/darwin/common-config.nix
          ./hosts/Alyx/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mz = import ./shared/home.nix;
          }
        ];
      };
      G-Man = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules =
        [
          ./shared/common-config.nix
          ./shared/darwin/common-config.nix
          ./hosts/G-Man/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mz = import ./shared/home.nix;
          }
        ];
      };
    };
  };
}

