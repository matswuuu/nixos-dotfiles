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
    mtsw-bar = {
      url = "github:matswuuu/mtsw-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, catppuccin, mtsw-bar, ... } @inputs:
    let
      mkHost = import ./mkHost.nix {
        inherit nixpkgs home-manager catppuccin mtsw-bar;
      };

      main = mkHost {
        system = "x86_64-linux";
        hostName = "main";
        username = "matswuuu";
      };
      laptop = mkHost {
        system = "x86_64-linux";
        hostName = "laptop";
        username = "matswuuu";
      };
    in
  {
    nixosConfigurations = {
      main = main.nixos;
      laptop = laptop.nixos;
    };

    homeConfigurations = {
      "${main.meta.username}@${main.meta.hostName}" = main.home;
      "${laptop.meta.username}@${laptop.meta.hostName}" = laptop.home;
    };
  };
}