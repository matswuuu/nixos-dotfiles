{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, catppuccin, ... } @inputs:
    let
      vars = import ./vars.nix;
    in {

    nixosConfigurations.${vars.hostName} = nixpkgs-stable.lib.nixosSystem {
      system = "${vars.system}";
      modules = [
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        ./os/configuration.nix
      ];
    };

    programs.home-manager = {
      enable = true;
    };

    homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
      modules = [
        ./home-manager/home.nix
        catppuccin.homeModules.catppuccin
      ]; 
    };
  };
}
