{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      experimental = true;
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
