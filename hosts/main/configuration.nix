{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ./packages.nix
    ./hardware/cpu.nix
    ./hardware/gpu.nix
    ./hardware/hardware-configuration.nix
  ];
}