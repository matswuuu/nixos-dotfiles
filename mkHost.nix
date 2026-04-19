{ nixpkgs, home-manager, sops-nix, catppuccin, mtsw-bar, inputs }:

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

    specialArgs = {
      username = username;
      hostName = hostName;
    };

    modules = [
      home-manager.nixosModules.home-manager 
      sops-nix.nixosModules.sops
      catppuccin.nixosModules.catppuccin
      
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ./home-manager/home.nix;

          extraSpecialArgs = {
            inputs = inputs;
          };

          sharedModules = [
            sops-nix.homeManagerModules.sops
            catppuccin.homeModules.catppuccin
            mtsw-bar.homeModules.mtsw-bar
          ] ++ homeModules;
        };
      }

      ./os/configuration.nix
      ./hosts/${hostName}/configuration.nix
    ] ++ nixosModules;
  };

  meta = {
    inherit username hostName system;
  };
}
