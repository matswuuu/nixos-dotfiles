{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ../../nixos/profiles/desktop-niri.nix
    ./networking.nix
    ./hardware/auto-cpufreq.nix
    ./hardware/hardware-configuration.nix
  ];
}
