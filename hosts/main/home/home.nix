{ pkgs, lib, ... }:

{
  imports = [
    
  ];

  session.niri = {  
    main-path = ./config.kdl;
  };

  services.notification-light = {
    enable = true;
    duration = 0.5;
    apps = {
      telegram = { r = 138; g = 173; b = 244; };
      vesktop = { r = 88; g = 101; b = 242; };
      discord = { r = 88; g = 101; b = 242; };
    };
  };
}
