{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    ../../nixos/profiles/desktop-niri.nix
    ../../nixos/hardware/openrgb.nix
    ../../nixos/services/ollama/default.nix
    ../../nixos/services/hermes/default.nix
    #../../nixos/services/lact/default.nix
    ./game/steam.nix
    ./network/networking.nix
    ./packages.nix
    ./hardware/disk2.nix
    ./hardware/disk3.nix
    ./hardware/gpu.nix
    ./hardware/hardware-configuration.nix
    ./hardware/swap.nix
  ];

  security.rtkit.enable = true;
}
