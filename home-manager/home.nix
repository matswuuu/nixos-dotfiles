{
  imports = [
    ./packages.nix
    ./modules/kitty/kitty.nix
    ./modules/gtk.nix
    ./modules/wofi.nix
    ./modules/java.nix
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
