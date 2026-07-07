{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
#    extraModulePackages = [ config.boot.kernelPackages.amneziawg ];
    kernelModules = [ "uinput" ];
  };
}
