{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ./networking.nix
    ./hardware/auto-cpufreq.nix
    ./hardware/hardware-configuration.nix
  ];
}