{
  description = ''
    SL Goetz NixOS
    skyeav@skyemac
    26.05 (Yarara) x86_64
    03-19-2026
  '';
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      flake.nixosConfigurations.skyemac = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/hardware.nix
          ./modules/skyeav/user.nix
          home-manager.nixosModules.home-manager
          ./modules/skyeav/home.nix
          ./modules/settings.nix
          ./modules/kernel.nix
          ./modules/services.nix
          ./modules/virtualization.nix
          ./modules/global.nix
          ./modules/networking.nix
        ];
      };
    };
}