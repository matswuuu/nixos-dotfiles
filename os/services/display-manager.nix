{
  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      wayland = {
        enable = true;
      };

      theme = "catppuccin";
      settings = {
        Theme = {
          Current = "catppuccin";
        };
      };
    };
  };
  catppuccin = {
    sddm = {
      enable = true;
      background = "~/.config/hypr/wallpapers/1.png";
    };
  };
}