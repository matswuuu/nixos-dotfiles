{ config, pkgs, ... }:
{
  boot.kernelParams = [ "pcie_aspm=off" ];
  networking = {
    hostName = "main";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      dispatcherScripts = [
        {
          source = pkgs.writeScript "30-disable-wifi-powersave" ''
            #!/bin/sh
            export PATH=${pkgs.iw}/bin:$PATH
            case "$2" in
              up|vpn-up|connectivity-change)
                iw dev "$1" set power_save off 2>/dev/null || true
                ;;
            esac
          '';
        }
      ];
    };
    timeServers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
    firewall = {
      enable = true;
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
