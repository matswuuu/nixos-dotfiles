{ inputs, lib, config, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  imports = [
    ./i18n.nix
    ./gc.nix
    ./networking.nix
    ./users.nix
    ./packages.nix
    ./hyprland.nix
    ./bluetooth.nix
    ./qt.nix
    ./services/display-manager.nix
    ./services/flatpak.nix
    ./services/openssh.nix
    ./services/security.nix
    ./services/udisk.nix
    ./services/upower.nix
    ./programs/amnezia-vpn.nix
    ./programs/cooler-control.nix
    ./programs/docker.nix
    ./programs/fish.nix
    ./programs/ssh.nix
  ] ++ (vars.profiles.${vars.activeProfile}.modules or []);

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.05";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
