{ inputs, pkgs, ...}:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
  ];
}