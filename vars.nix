{
  activeProfile = "main";
  profiles = {
    "main" = {
      system = "x86_64-linux";
      username = "matswuuu";
      hostName = "main";
      flakeLocation = "~/nixos-dotfiles";
      modules = [
        ./os/programs/steam.nix
      ];
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
      hostName = "laptop";
      flakeLocation = "~/nixos-dotfiles";
      modules = [];
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