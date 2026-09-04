{
  nixpkgs,
  home-manager,
  sops-nix,
  catppuccin,
  mtsw-bar,
  hermes-agent,
  inputs,
}:

{
  system,
  hostName,
  username,
  nixosModules ? [ ],
  homeModules ? [ ],
}:
{
  nixos = nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit username hostName;
    };

    modules = [
      home-manager.nixosModules.home-manager
      sops-nix.nixosModules.sops
      catppuccin.nixosModules.catppuccin
      hermes-agent.nixosModules.default

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ../home/default.nix;

          extraSpecialArgs = {
            inherit inputs username;
          };

          sharedModules = [
            sops-nix.homeManagerModules.sops
            catppuccin.homeModules.catppuccin
            mtsw-bar.homeModules.mtsw-bar
          ]
          ++ homeModules;
        };
      }

      ../nixos/profiles/base.nix
      ../hosts/${hostName}/configuration.nix
    ]
    ++ nixosModules;
  };

  meta = {
    inherit username hostName system;
  };
}
