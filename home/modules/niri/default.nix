{ config, lib, pkgs, ... }:
  let
    cfg = config.session.niri;
  in
{
  imports = [
    ./awww.nix
  ];

  options.session.niri = {
    main-path = lib.mkOption {
      type = lib.types.path;
      description = "Path for the main niri config";
    };
  };

  config = {
    home.file = {
      ".config/niri/config.kdl".source = cfg.main-path;
      ".config/niri/common.kdl".source = ./common.kdl;
      ".config/niri/binds.kdl".source = ./binds.kdl;
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
  };
}