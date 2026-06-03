{ inputs, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
    vulkan-loader
    pciutils
  ];
}