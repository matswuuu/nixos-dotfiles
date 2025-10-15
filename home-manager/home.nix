{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/kitty/kitty.nix
    ./modules/gtk.nix
    ./modules/java.nix
    ./modules/wofi/wofi.nix
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
    ./modules/theme/catppuccin.nix
  ];

  home = {
    username = "matswuuu";
    homeDirectory = "/home/matswuuu";
    stateVersion = "25.05";
  };
}
