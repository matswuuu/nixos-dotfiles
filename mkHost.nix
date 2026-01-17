{ nixpkgs, home-manager, catppuccin, mtsw-bar }:

{ 
  system,
  hostName,
  username,
  nixosModules ? [ ],
  homeModules ? [ ]
}:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  nixos = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      catppuccin.nixosModules.catppuccin
      home-manager.nixosModules.home-manager 
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
      ./os/configuration.nix
      ./hosts/${hostName}/configuration.nix
    ] ++ nixosModules;
  };

  home = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./home-manager/home.nix
      catppuccin.homeModules.catppuccin
      mtsw-bar.homeModules.mtsw-bar
    ] ++ homeModules;
  };

  meta = {
    inherit username hostName system;
  };
}
