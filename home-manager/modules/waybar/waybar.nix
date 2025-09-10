{
  home.file = {
    ".config/waybar/config.jsonc".source = ./config.jsonc;
    ".config/waybar/style.css".source = ./style.css;

    # Scripts
    ".config/waybar/scripts/cpu_temp.sh" = {
      source = ./scripts/cpu_temp.sh;
      executable = true;
    };
    ".config/waybar/scripts/ip_info.sh" = {
      source = ./scripts/ip_info.sh;
      executable = true;
    };
  };
  programs.waybar = {
    enable = true;
  };
  catppuccin.waybar = {
    mode = "createLink";
  };
}
