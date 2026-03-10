{
  programs.niri.enable = true;
  # programs.niri.settings = {
    # binds = {
    #   "Mod+Return" = { spawn = "kitty"; };
    # };
  #   outputs = {
  #     "eDP-1" = {
  #       scale = 1.25;
  #       transform = "normal";
  #     };
  #   };
  # };

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
}