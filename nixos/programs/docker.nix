{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraPackages = [
      pkgs.docker-buildx
    ];
    daemon.settings = {
      dns = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    };
  };
}
