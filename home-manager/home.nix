{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/bar/default.nix
    ./modules/kitty/default.nix
    ./modules/java/default.nix
    ./modules/wofi/default.nix
    ./modules/hyprland/default.nix
    ./modules/btop/default.nix
    ./modules/theme/gtk.nix
    ./modules/theme/qt.nix
    ./modules/theme/catppuccin.nix
  ];

  home = {
    username = "matswuuu";
    homeDirectory = "/home/matswuuu";
    stateVersion = "25.11";
  };
}
