{ inputs, lib, config, pkgs, ...}:
{
  imports = [
    ./game/steam.nix
    ./network/networking.nix
    ./packages.nix
    ./hardware/cpu.nix
    ./hardware/gpu.nix
    ./hardware/hardware-configuration.nix
  ];
}