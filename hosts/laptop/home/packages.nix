{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    arduino-ide
  ];
}
