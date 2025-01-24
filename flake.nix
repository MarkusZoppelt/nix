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

  outputs = { self, nixpkgs, darwin, home-manager }:
    let
      specialArgs = { inputs = { inherit self nixpkgs; }; };
      mkSystem = system: modules:
        nixpkgs.lib.nixosSystem { inherit system modules specialArgs; };
    in {
      nixosConfigurations = {
        NixOS = mkSystem "x86_64-linux" [
          ./shared/nixos/common-config.nix
          ./hosts/NixOS/configuration.nix
        ];

        Orbstack =
          mkSystem "aarch64-linux" [ ./hosts/Orbstack/configuration.nix ];
      };

      homeConfigurations = {
        Linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./shared/linux/home.nix ];
        };
      };

      darwinConfigurations = {
        Darwin = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./shared/darwin/common-config.nix ];
        };
      };
    };
}
