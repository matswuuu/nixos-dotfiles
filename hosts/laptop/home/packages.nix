{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    cura
    arduino-ide
  ];
}
