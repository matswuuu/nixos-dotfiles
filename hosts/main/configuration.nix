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

  environment.systemPackages = with pkgs; [
    anydesk
  ];

  nixpkgs.overlays = [
      (final: prev: {
        anydesk = prev.anydesk.overrideAttrs (old: rec {
          version = "8.0.3";

          src = prev.fetchurl {
            url = "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz";
            hash = "sha256-Mjl17hh5A/pwRAi7giL1SJYlQ61O0SXX+KeH8STZ4bs=";
          };
        });
      })
    ];
}
