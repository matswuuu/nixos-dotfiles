{ config, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
#    extraModulePackages = [ config.boot.kernelPackages.amneziawg ];
    kernelModules = [ "uinput" ];
  };
}
