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
      Gordon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = 
        [
          ./shared/common-config.nix
          ./shared/nixos/common-config.nix
          ./hosts/Gordon/configuration.nix
        ];
        specialArgs = { inputs = { inherit self; inherit nixpkgs; inherit darwin; }; };
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
        ];
      };
      G-Man = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules =
        [
          ./shared/common-config.nix
          ./shared/darwin/common-config.nix
          ./hosts/G-Man/configuration.nix
        ];
      };
    };
  };
}

