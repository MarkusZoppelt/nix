{
  description = "MarkusZoppelt's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
    }:
    let
      user = "mz";
      name' = "Markus Zoppelt";
      email = "markus@zoppelt.net";
      specialArgs = { inherit user name' email; };
    in
    {
      nixosConfigurations = {
        NixOS = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          system = "x86_64-linux";
          modules = [
            ./nixos/common.nix
            ./nixos/virtualization.nix
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
      };

      darwinConfigurations = {
        Darwin = darwin.lib.darwinSystem {
          inherit specialArgs;

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
        checks.aarch64-darwin.mac = self.darwinConfigurations.darwin-arm64.system;
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
