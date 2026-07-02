{ config, ... }:

{
  home.file = {
    ".config/cliphist/config".text = ''
      max-items 100000
      max-store-size 1GB
      db-path ${config.home.homeDirectory}/cliphist/db
    '';
  };
}