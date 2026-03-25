{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/alacritty/default.nix
    ./modules/bar/default.nix
    ./modules/cliphist/default.nix
    ./modules/fastfetch/default.nix
    ./modules/wofi/default.nix
    ./modules/java/default.nix
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
