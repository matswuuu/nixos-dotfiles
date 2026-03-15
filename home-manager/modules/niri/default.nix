<<<<<<< HEAD:home-manager/modules/niri/default.nix
{ pkgs, ... }:

{
  imports = [
    ./swww.nix
  ];

  home.file = {
    ".config/niri/config.kdl".source = ./config.kdl;
    ".config/niri/binds.kdl".source = ./binds.kdl;
    ".config/niri/main.kdl".source = ./main.kdl;
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Rootless Xwayland inside Wayland";
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
=======
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
    };
  };
}
>>>>>>> 43f07eae7f18a275dcfbb835ed9b6da8f4bfd285:home-manager/modules/hyprland/default.nix
