{ pkgs, ... }:

{
  imports = [
    ./packages.nix
  ];

  session.niri = {  
    main-path = ./config.kdl;
  };
}
