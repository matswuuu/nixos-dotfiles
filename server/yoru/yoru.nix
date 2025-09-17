{ pkgs, ... }:

{
  # systemd.services.yoru = {
  #   description = "Yoru home manager";
  #   after = [ 
  #     "docker.service" 
  #     "network-online.target" 
  #   ];
  #   requires = [ 
  #     "docker.service" 
  #   ];
  #   wantedBy = [
  #     "multi-user.target" 
  #   ];

  #   serviceConfig = {
  #     WorkingDirectory = "/mnt/data";
  #     ExecStart = "${pkgs.docker-compose}/bin/docker-compose up --remove-orphans";
  #     ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
  #     Restart = "always";
  #     RestartSec = 5;
  #   };
  # };
}
