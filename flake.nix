{
  description = "Skye Lane Goetz: NixOS Flake (1.0.0)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    openconnect-sso.url = "github:vlaci/openconnect-sso";
  };
  outputs = inputs @ {self, nixpkgs, flake-parts, nix-cachyos-kernel, home-manager, openconnect-sso, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
      ];
      flake = {
        nixosConfigurations.skyeav = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {_module.args = {inherit inputs;};}
            home-manager.nixosModules.home-manager
            ./configuration.nix
          ];
        };
      };
    };
}
