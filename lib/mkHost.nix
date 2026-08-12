{ nixpkgs, home-manager, sops-nix, catppuccin, mtsw-bar, inputs }:

{
  system,
  hostName,
  username,
  nixosModules ? [ ],
  homeModules ? [ ]
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

      {
        nixpkgs.overlays = [
          (final: prev: {
            libdisplay-info = prev.libdisplay-info.overrideAttrs {
              version = "0.3.0";
              src = prev.fetchFromGitLab {
                domain = "gitlab.freedesktop.org";
                owner = "emersion";
                repo = "libdisplay-info";
                rev = "0.3.0";
                hash = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
              };
            };
          })
        ];
      }

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
          ] ++ homeModules;
        };
      }

      ../nixos/profiles/base.nix
      ../hosts/${hostName}/configuration.nix
    ] ++ nixosModules;
  };

  meta = {
    inherit username hostName system;
  };
}
