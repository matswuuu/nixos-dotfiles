{
  activeProfile = "laptop";
  profiles = {
    "main" = {
      system = "x86_64-linux";
      username = "matswuuu";
      flakeLocation = "~/nixos-dotfiles";
      hyprland = [
        "~/.config/hypr/main/monitor.conf"
      ];
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
    "laptop" = {
      system = "x86_64-linux";
      username = "matswuuu";
      flakeLocation = "~/nixos-dotfiles";
      hyprland = [
        "~/.config/hypr/laptop/monitor.conf"
      ];
      catppuccin = {
        flavor = "macchiato";
        accent = "mauve";
      };
    };
  };
}