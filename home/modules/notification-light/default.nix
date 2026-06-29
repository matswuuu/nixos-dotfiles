{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.notification-light;
  secret = name: config.sops.secrets.${name}.path;

  tapo = pkgs.python314.pkgs.buildPythonPackage rec {
    pname = "tapo";
    version = "0.8.12";
    format = "pyproject";
    doCheck = false;
    src = pkgs.python314.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-7wrcMOwh55O4367vj0KgQvk642LsNRn5mt1hmKiiJX0=";
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-HDgP3ZK0T4t514E+MYS02G39CwVqDbaOPQyFoqaVx+c=";
    };
    nativeBuildInputs = with pkgs; [
      rustc cargo rustPlatform.maturinBuildHook rustPlatform.cargoSetupHook
    ];
    propagatedBuildInputs = with pkgs.python314.pkgs; [ requests ];
  };

  pythonEnv = pkgs.python314.withPackages (ps: with ps; [
    dbus-python
    pygobject3
    tapo
  ]);

  configJson = pkgs.writeText "notification-light-config.json" (builtins.toJSON {
    apps = cfg.apps;
    duration = cfg.duration;
    tapo = {
      email_path = secret "bar/tapo/email";
      password_path = secret "bar/tapo/password";
      ip_path = secret "bar/tapo/ip";
    };
  });

  pkg = pkgs.writeShellScriptBin "notification-light" ''
    exec ${pythonEnv}/bin/python ${./notification-light.py}
  '';
in
{
  options.services.notification-light = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable notification lightstrip";
    };

    apps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          r = mkOption { type = types.int; description = "Red 0-255"; };
          g = mkOption { type = types.int; description = "Green 0-255"; };
          b = mkOption { type = types.int; description = "Blue 0-255"; };
        };
      });
      default = {};
      example = {
        telegram = { r = 138; g = 173; b = 244; };
        vesktop = { r = 88; g = 101; b = 242; };
      };
      description = "App name patterns to RGB color mappings";
    };

    duration = mkOption {
      type = types.float;
      default = 0.5;
      description = "Flash duration in seconds";
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/notification-light/config.json".source = configJson;

    home.packages = [ pkg ];

    systemd.user.services.notification-light = {
      Unit = {
        Description = "Notification Lightstrip Controller";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkg}/bin/notification-light";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
