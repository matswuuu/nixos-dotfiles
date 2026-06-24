{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ../../nixos/profiles/desktop-niri.nix
    ./game/steam.nix
    ./network/networking.nix
    ./packages.nix
    ./hardware/cpu.nix
    ./hardware/gpu.nix
    ./hardware/hardware-configuration.nix
  ];

  services.xserver = {
    enable = true;
  };

  
  environment.systemPackages = with pkgs; [
    openbox
    xterm
    xdotool
    xclip
    xsel
    xwayland-satellite
  ];
}
