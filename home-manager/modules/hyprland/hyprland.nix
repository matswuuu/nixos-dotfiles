  let
    vars = import ./../../../vars.nix;
  in
{
  home.file = {
    ".config/hypr/common.conf".source = ./common.conf;
    ".config/hypr/binds.conf".source = ./binds.conf;
    ".config/hypr/env.conf".source = ./env.conf;
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
