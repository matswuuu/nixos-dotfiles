{ config, ... }:
  let
    secret = name: config.sops.secrets.${name}.path;
  in
{
  home.file = {
    ".config/mtsw-bar/network_latency.sh".source = ./network_latency.sh;
  };
  programs.mtsw-bar = {
    enable = true;
    settings = {
      monitors = [ "DP-1" "eDP-1" ];
      bar = {
        tray = {
          iconOrder = [
            "chrome_status_icon_1" # Discord
            "telegram"
          ];
        };
        network = {
          hosts = [
            {
              host = "ru.nevergodz.dev";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST 443";
            }
            {
              host = "de.nevergodz.dev";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST 44443";
            }
            {
              host = "se.nevergodz.dev";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST 443";
            }
            {
              host = "jp.nevergodz.dev";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST 44443";
            }
          ];
        };
        light = {
          tapo = {
            email = secret "bar/tapo/email";
            ip = secret "bar/tapo/ip";
            password = secret "bar/tapo/password";
            python = "python3";
          };
        };
      };
    };
  };
}