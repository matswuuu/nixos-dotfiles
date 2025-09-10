{ config, lib, pkgs, modulesPath, ... }:

{
  # imports = [
  #   (modulesPath + "/installer/scan/not-detected.nix")
  # ];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/3e96cd52-7e16-4228-adc3-d20bffe64ec5";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/6C97-A756";
  #   fsType = "vfat";
  #   options = [ "fmask=0077" "dmask=0077" ];
  # };

  # fileSystems."/mnt/data" = {
  #   device = "/dev/sda2";
  #   fsType = "ntfs-3g";
  #   options = [ "defaults" ];
  # };

  # swapDevices = [
  #    { device = "/dev/disk/by-uuid/97bd1f23-80ce-46a3-ab6e-2168f0685e4e"; }
  # ];

  # # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # # (the default) this is the recommended approach. When using systemd-networkd it's
  # # still possible to use this option, but it's recommended to use it in conjunction
  # # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [
   (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/77002d6c-b737-40a1-8d59-749565d1626b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2BCD-0FEA";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/07469d58-c747-47e8-94a3-5bcc6ae0615b"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
