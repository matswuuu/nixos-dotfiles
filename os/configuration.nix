{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  imports = [
    ./i18n.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
    ./hyprland.nix
    ./services/display-manager.nix
    ./services/flatpak.nix
    ./services/openssh.nix
    ./programs/ssh.nix
    ./programs/fish.nix
    ./programs/amnezia-vpn.nix
  ]
  ++ (vars.profiles.${vars.activeProfile}.modules or []);

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.05";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprland = {};
    login.enableKwallet = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ 
        "https://aseipp-nix-cache.global.ssl.fastly.net"
        "https://ezkea.cachix.org" 
      ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" 
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "6:00" ];
      options = "--delete-older-than 14d";
    };
  }
}
