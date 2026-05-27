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
              host = secret "bar/network/host1/ip";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST ${secret "bar/network/host1/port"}";
            }
            {
              host = secret "bar/network/host2/ip";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST ${secret "bar/network/host2/port"}";
            }
            {
              host = secret "bar/network/host3/ip";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST ${secret "bar/network/host3/port"}";
            }
            {
              host = secret "bar/network/host4/ip";
              pingCommand = "bash ~/.config/mtsw-bar/network_latency.sh $HOST ${secret "bar/network/host4/port"}";
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