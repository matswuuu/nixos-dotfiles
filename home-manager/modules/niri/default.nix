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