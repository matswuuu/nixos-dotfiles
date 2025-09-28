{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      experimental = true;
      dns = [ "1.1.1.1" "8.8.8.8"];
      # default-address-pools = [
      #   {
      #     base = "192.168.0.0/16";
      #     size = 24;
      #   }
      # ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  networking.extraRoutingOptions = ''
    ip rule add from 172.17.0.0/16 table 200
    ip route add default via 192.168.1.1 dev wlo1 table 200
  '';
}
