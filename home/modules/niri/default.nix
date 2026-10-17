{
  config,
  lib,
  pkgs,
  ...
}:
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

    # niri's include takes a literal path: it does not glob, and it errors out
    # if the file is absent. So extras are appended to common.kdl here rather
    # than included by name, and the module listing one owns writing it.
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "extra.kdl" ];
      description = ''
        Extra niri config files to include at the end of common.kdl, named
        relative to the niri config directory. Whoever lists a file here is
        responsible for deploying it, since niri refuses to start without it.
      '';
    };
  };

  config = {
    home.file = {
      ".config/niri/config.kdl".source = cfg.main-path;
      ".config/niri/binds.kdl".source = ./binds.kdl;

      ".config/niri/common.kdl".text = lib.concatStrings [
        (builtins.readFile ./common.kdl)
        "\n"
        (lib.concatMapStrings (name: "include \"./${name}\"\n") cfg.includes)
      ];
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
