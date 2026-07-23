{ config, ... }:

{
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };
}