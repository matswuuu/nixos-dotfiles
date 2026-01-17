{ inputs, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
  ];
}