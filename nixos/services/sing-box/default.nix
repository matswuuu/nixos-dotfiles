{ config, lib, pkgs, username, ... }:

let
  cfg = config.services.sing-box;
  proxyDir = "/home/${username}/nixos-dotfiles/proxy";
  baseSettings = builtins.fromJSON (builtins.readFile ../../../proxy/sing-box.json);

  applyDefaultInterface = settings:
    if cfg.defaultInterface == null then
      settings
    else
      settings // {
        outbounds = builtins.map
          (outbound:
            if (outbound.tag or null) == "direct" then
              outbound // { bind_interface = cfg.defaultInterface; }
            else
              outbound)
          (settings.outbounds or [ ]);
        route = (settings.route or { }) // {
          default_interface = cfg.defaultInterface;
        };
      };
in
{
  options.services.sing-box.defaultInterface = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "wlp1s0";
    description = ''
      Host network interface sing-box should use for direct/default routing.
      When set, this overrides route.default_interface and the direct outbound
      bind_interface in the Docker proxy sing-box config.
    '';
  };

  config = {
    systemd.services.proxy-containers = {
      description = "Docker proxy containers";
      wantedBy = [ "multi-user.target" ];
      after = [
        "docker.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      requires = [ "docker.service" ];

      path = [
        pkgs.docker
        pkgs.docker-compose
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = proxyDir;
        ExecStartPre = [
          "${pkgs.coreutils}/bin/test -f ${proxyDir}/config/de.conf"
          "${pkgs.coreutils}/bin/test -f ${proxyDir}/config/jp.conf"
          "${pkgs.coreutils}/bin/test -f ${proxyDir}/config/se.conf"
          "${pkgs.coreutils}/bin/test -f ${proxyDir}/config/fi.conf"
          "${pkgs.coreutils}/bin/test -f ${proxyDir}/config/pl.conf"
        ];
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up --build --detach --remove-orphans";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        TimeoutStartSec = "10min";
        TimeoutStopSec = "2min";
      };
    };

    services.sing-box = {
      enable = true;
      settings = applyDefaultInterface baseSettings;
    };

    systemd.services.sing-box = {
      after = [ "proxy-containers.service" ];
      requires = [ "proxy-containers.service" ];
    };
  };
}
