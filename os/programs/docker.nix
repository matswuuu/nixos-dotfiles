{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      dns = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    };
  };
}
