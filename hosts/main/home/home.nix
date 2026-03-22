{ pkgs, ... }:

{
  imports = [
    
  ];

  session.niri = {  
    main-path = ./config.kdl;
  };
}
