{
  boot.kernelParams = [ "intel_pstate=enable" ];
  services.thermald = {
    enable = true;
  };
  powerManagement.cpuFreqGovernor = "schedutil";
}