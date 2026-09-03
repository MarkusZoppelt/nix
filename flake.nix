{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    hex.url = "github:anomalyco/hex";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      home-manager,
      lanzaboote,
      llm-agents,
      hex,
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
          ;
      };
      llmOverlay = llm-agents.overlays.shared-nixpkgs;
      unstableOverlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
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
            {
              nixpkgs.overlays = [
                unstableOverlay
                llmOverlay
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${user} = {
                imports = [
                  ./home.nix
                  ./nixos/desktop
                  hex.homeManagerModules.hex
                ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        Darwin = darwin.lib.darwinSystem {
          inherit specialArgs;

          system = "aarch64-darwin";
          modules = [
            ./lib/nix-settings.nix
            ./darwin.nix
            {
              nixpkgs.overlays = [
                unstableOverlay
                (final: prev: {
                  direnv = prev.direnv.overrideAttrs (_: {
                    doCheck = false;
                  });
                })
                llmOverlay
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

      checks.aarch64-darwin.mac = self.darwinConfigurations.Darwin.system;
      checks.x86_64-linux.gordon = self.nixosConfigurations.Gordon.config.system.build.toplevel;
      formatter = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
