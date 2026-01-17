{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ./hardware/auto-cpufreq.nix
    ./hardware/hardware-configuration.nix
  ];
}