{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "uinput" ];
  };

#      programs.hyprland = {
#        enable = true;
#        withUWSM = true;
#        xwayland.enable = true;
#      };
}
