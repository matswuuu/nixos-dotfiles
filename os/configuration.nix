{ inputs, lib, config, pkgs, username, hostName, ...}:
{
  imports = [
    ./i18n.nix
    ./gc.nix
    ./users.nix
    ./packages.nix
    ./bluetooth.nix
    ./niri.nix
    ./sops/default.nix
    ./services/greetd.nix
    ./services/flatpak.nix
    ./services/openssh.nix
    ./services/security.nix
    ./services/udisk.nix
    ./services/upower.nix
    ./programs/amnezia/amnezia-vpn.nix
    ./programs/docker.nix
    ./programs/shell.nix
    ./programs/ssh.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [ config.boot.kernelPackages.amneziawg ];
    kernelModules = [ "amneziawg" "uinput" ];
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';
  users.groups.input.members = [ "matswuuu" ];

  system.stateVersion = "25.11";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "06:00";
      options = "--delete-older-than 14d";
    };
  };
}
