{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    direnv-instant.url = "github:Mic92/direnv-instant";
    # Needs the package token in /etc/nix/netrc until Rex's first public release
    rex.url = "https://pkgs.superlogical.com/rex/nix/preview.tar.gz";
    hex = {
      url = "github:anomalyco/hex";
      # Needs a newer rustc than 26.05 ships
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      darwin,
      lanzaboote,
      llm-agents,
      direnv-instant,
      rex,
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
          llm-agents
          direnv-instant
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
                  rex.homeManagerModules.default
                  hex.homeManagerModules.default
                ];
                programs.rex.enable = true;
                services.rex = {
                  enable = true;
                  tailscale.enable = true;
                };
                programs.hex = {
                  enable = true;
                  autostart = true;
                  systemdTarget = "hyprland-session.target";
                };
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
            ./lib/harmonia.nix
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
