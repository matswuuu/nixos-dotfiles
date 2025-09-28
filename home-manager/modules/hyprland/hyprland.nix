  let
    vars = import ./../../../vars.nix;
  in
{
  home.file = {
    ".config/hypr/common.conf".source = ./common.conf;
    ".config/hypr/binds.conf".source = ./binds.conf;
    ".config/hypr/env.conf".source = ./env.conf;
    ".config/hypr/main/monitor.conf".source = ./main/monitor.conf;
    ".config/hypr/laptop/monitor.conf".source = ./laptop/monitor.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    ".config/hypr/wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    settings = {
      source = [
        "~/.config/hypr/common.conf"
        "~/.config/hypr/env.conf"
        "~/.config/hypr/binds.conf"
      ] ++ (vars.profiles.${vars.activeProfile}.hyprland or []);
      exec-once = [
        "THERMAL_ZONE=${vars.profiles.${vars.activeProfile}.waybar.thermal.cpuZone} waybar"
      ];
    };
  };
}
