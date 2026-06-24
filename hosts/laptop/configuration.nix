{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ../../nixos/profiles/desktop-niri.nix
    ./networking.nix
    ./game/steam.nix
    ./hardware/auto-cpufreq.nix
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
