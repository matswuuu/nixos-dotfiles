{ config, lib, pkgs, username, ... }:

let
  cfg = config.services.sing-box;
  proxyDir = "/home/${username}/nixos-dotfiles/proxy";
  awgConfigDir = toString cfg.awgConfigDir;
  proxyConfigFiles = [
    "de.conf"
    "jp.conf"
    "se.conf"
    "fi.conf"
    "pl.conf"
  ];
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
  # options.services.sing-box = {
  #   defaultInterface = lib.mkOption {
  #     type = lib.types.nullOr lib.types.str;
  #     default = null;
  #     example = "wlp1s0";
  #     description = ''
  #       Host network interface sing-box should use for direct/default routing.
  #       When set, this overrides route.default_interface and the direct outbound
  #       bind_interface in the Docker proxy sing-box config.
  #     '';
  #   };

  #   awgConfigDir = lib.mkOption {
  #     type = lib.types.path;
  #     default = "/home/${username}/proxy/config";
  #     example = "/var/lib/amneziawg/config";
  #     description = ''
  #       Directory containing AmneziaWG config files mounted into the Docker
  #       proxy containers.
  #     '';
  #   };
  # };

  # config = {
  #   systemd.services.proxy-containers = {
  #     description = "Docker proxy containers";
  #     wantedBy = [ "multi-user.target" ];
  #     after = [
  #       "docker.service"
  #       "network-online.target"
  #     ];
  #     wants = [ "network-online.target" ];
  #     requires = [ "docker.service" ];

  #     path = [
  #       pkgs.docker
  #       pkgs.docker-compose
  #     ];

  #     environment.AWG_CONFIG_DIR = awgConfigDir;

  #     serviceConfig = {
  #       Type = "oneshot";
  #       RemainAfterExit = true;
  #       WorkingDirectory = proxyDir;
  #       ExecStartPre = pkgs.writeShellScript "proxy-containers-preflight" ''
  #         config_dir=${lib.escapeShellArg awgConfigDir}
  #         missing=0
  #         for config in ${lib.escapeShellArgs proxyConfigFiles}; do
  #           if [[ ! -f "$config_dir/$config" ]]; then
  #             echo "missing $config_dir/$config" >&2
  #             missing=1
  #           fi
  #         done

  #         if [[ "$missing" -ne 0 ]]; then
  #           echo "proxy-containers.service requires local AmneziaWG configs in $config_dir" >&2
  #           exit 1
  #         fi
  #       '';
  #       ExecStart = "${pkgs.docker-compose}/bin/docker-compose up --build --detach --remove-orphans";
  #       ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
  #       TimeoutStartSec = "10min";
  #       TimeoutStopSec = "2min";
  #     };
  #   };

  #   services.sing-box = {
  #     enable = true;
  #     settings = applyDefaultInterface baseSettings;
  #   };

  #   systemd.services.sing-box = {
  #     after = [ "proxy-containers.service" ];
  #     requires = [ "proxy-containers.service" ];
  #   };
  # };
}
