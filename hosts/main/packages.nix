{ inputs, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
  ];
}