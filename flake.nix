{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, determinate, darwin, home-manager }: {
    nixosConfigurations = {
      Gordon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = 
        [
          ./shared/nixos/common-config.nix
          ./hosts/Gordon/configuration.nix
        ];
        specialArgs = { inputs = { inherit self; inherit nixpkgs; inherit darwin; }; };
      };
    };

    # for Linux, use home-manager
    homeConfigurations = {
        Linux = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          determinate.darwinModules.default
          ./shared/linux/home.nix
        ];
      };
    };

    darwinConfigurations = {
      Alyx = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = 
        [ 
          determinate.darwinModules.default
          ./shared/darwin/common-config.nix
          ./hosts/Alyx/configuration.nix
        ];
      };
      G-Man = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules =
        [
          determinate.darwinModules.default
          ./shared/darwin/common-config.nix
          ./hosts/G-Man/configuration.nix
        ];
      };
    };
  };
}
