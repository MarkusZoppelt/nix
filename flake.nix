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
    user = "mz";
    name' = "Markus Zoppelt";
    email = "markus@zoppelt.net";
    specialArgs = { inherit user name' email; };

    inherit (nixpkgs) legacyPackages;
  in
  {
    nixosConfigurations = {
      NixOS = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "x86_64-linux";
        modules = [
          ./nixos/common.nix
          ./hosts/NixOS/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users."${user}" = {
              imports = [
                ./home.nix
              ];
            };
          }
        ];
      };
      NixOS-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./nixos/common.nix
          ./hosts/NixOS-aarch64/configuration.nix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users."${user}" = {
              imports = [ ./home.nix ];
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      Darwin = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users."${user}" = {
              imports = [ ./home.nix ];
            };
          }
        ];
      };
    };

    formatter = {
      x86_64-linux = legacyPackages.x86_64-linux.nixfmt-rfc-style;
      aarch64-linux = legacyPackages.aarch64-linux.nixfmt-rfc-style;
      aarch64-darwin = legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
  };
}
