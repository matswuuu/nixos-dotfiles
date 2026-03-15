{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/alacritty/default.nix
    ./modules/bar/default.nix
    ./modules/java.nix
    ./modules/wofi/wofi.nix
    ./modules/btop/default.nix
    ./modules/niri/default.nix
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
