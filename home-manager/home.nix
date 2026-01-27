{ pkgs, caelestia-shell, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/bar/default.nix
    ./modules/kitty/kitty.nix
    ./modules/java.nix
    ./modules/wofi/wofi.nix
    ./modules/hyprland/hyprland.nix
    ./modules/btop/default.nix
    ./modules/theme/gtk.nix
    ./modules/theme/qt.nix
    ./modules/theme/catppuccin.nix
  ];

  home = {
    username = "matswuuu";
    homeDirectory = "/home/matswuuu";
    stateVersion = "25.11";
    packages = [
      caelestia-shell.packages.x86_64-linux.with-cli
    ];
  };
}
