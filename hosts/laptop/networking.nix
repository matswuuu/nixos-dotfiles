{ config, ... }:
{
  networking = {
    hostName = "laptop";
    networkmanager = {
      enable = true;
    };
    timeServers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
  };

  # services.sing-box = {
  #   defaultInterface = "wlp1s0";
  # };
}
