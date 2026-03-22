{ config, ... }: 
{
  networking = {
    hostName = "main";
    networkmanager = {
      enable = true;
    };
    timeServers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
    firewall = {
      allowedTCPPorts = [ 
        7878
        8081 
        8080
        8085
        8096
        8686
        8989
        9117
        9696
      ];
    };
  };
}