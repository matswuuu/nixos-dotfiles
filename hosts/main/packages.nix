{ inputs, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvidia-container-toolkit
    vulkan-tools
    vulkan-loader
    pciutils
  ];
}