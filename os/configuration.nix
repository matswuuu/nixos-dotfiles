{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../vars.nix;
    modules = {
      "main" = [
        ./hardware/hardware-configuration-main.nix
        ./hardware/nvidia.nix
        ./programs/steam.nix
      ];
      laptop = [
        ./hardware/hardware-configuration-laptop.nix
      ];
    };
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
    ./programs/amnezia-vpn.nix
    ./programs/docker.nix
    ./programs/fish.nix
    ./programs/ssh.nix
  ]
  ++ (modules.${vars.profile} or []);

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.05";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ 
      "https://aseipp-nix-cache.global.ssl.fastly.net"
      "https://ezkea.cachix.org" 
    ];
    trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" 
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    hyprland = {};
    login.enableKwallet = true;
  };
}
