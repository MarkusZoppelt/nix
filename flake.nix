{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      lanzaboote,
      llm-agents,
    }:
    let
      user = "mz";
      name' = "Markus Zoppelt";
      email = "markus@zoppelt.net";
      colors = import ./lib/colors.nix;
      specialArgs = {
        inherit
          user
          name'
          email
          colors
          llm-agents
          ;
      };
    in
    {
      nixosConfigurations = {
        Gordon = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          system = "x86_64-linux";
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./lib/nix-settings.nix
            ./nixos/common.nix
            ./hosts/NixOS/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${user} = {
                imports = [
                  ./home.nix
                  ./nixos/desktop
                ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        Alyx = darwin.lib.darwinSystem {
          inherit specialArgs;

          system = "aarch64-darwin";
          modules = [
            ./lib/nix-settings.nix
            ./darwin.nix
            {
              nixpkgs.overlays = [
                (final: prev: {
                  direnv = prev.direnv.overrideAttrs (_: {
                    doCheck = false;
                  });
                })
              ];
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${user} = {
                imports = [
                  ./home.nix
                ];
              };
            }
          ];
        };
      };

      checks.aarch64-darwin.mac = self.darwinConfigurations.Alyx.system;
      checks.x86_64-linux.gordon = self.nixosConfigurations.Gordon.config.system.build.toplevel;
      formatter = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
