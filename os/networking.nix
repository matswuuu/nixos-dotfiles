{ config, lib, pkgs, modulesPath, ... }: 
  let
    vars = import ./../vars.nix;
    profile = vars.profiles.${vars.activeProfile};
  in
{
  networking = {
    hostName = profile.hostName;
    networkmanager = {
      enable = true;
    };
    interfaces = {
      enp2s0 = {
        useDHCP = true;
      };
    };
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