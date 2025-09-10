{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "192.168.0.0/16";
          size = 24;
        }
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}