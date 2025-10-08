{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/kitty/kitty.nix
    ./modules/java.nix
    ./modules/wofi/wofi.nix
    ./modules/hyprland/hyprland.nix
    ./modules/quickshell/default.nix
    ./modules/theme/gtk.nix
    ./modules/theme/qt.nix
    ./modules/theme/catppuccin.nix
  ];

  home = {
    username = "matswuuu";
    homeDirectory = "/home/matswuuu";
    stateVersion = "25.05";
  };
}
