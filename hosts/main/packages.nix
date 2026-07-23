{ inputs, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
    pciutils
  ];
}
