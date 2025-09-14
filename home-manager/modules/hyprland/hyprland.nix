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
      ];
      monitor = vars.profiles.${vars.activeProfile}.hyprland.monitor;
    };
  };
}
