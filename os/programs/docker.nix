{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      experimental = true;
      # dns = [ "1.1.1.1" "8.8.8.8" ];
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
}
