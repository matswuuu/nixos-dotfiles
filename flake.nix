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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... } @inputs:
      let
        vars = import ./vars.nix;
        profile = vars.profiles.${vars.activeProfile};
        system = profile.system;
        pkgs = import nixpkgs { inherit system; };
      in 
    {
      nixosConfigurations.${profile.hostName} = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          ./os/configuration.nix
        ];
      };

      programs.home-manager = {
        enable = true;
      };

      homeConfigurations.${profile.username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./home-manager/home.nix
          catppuccin.homeModules.catppuccin
        ]; 
      };
  };
}
