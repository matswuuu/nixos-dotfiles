{ config, lib, pkgs, modulesPath, ... }: 
  let
    vars = import ./../vars.nix;
  in
{
  networking = {
    hostName = vars.profiles.${vars.activeProfile}.hostName;
    networkmanager.enable = true;
    proxy = {
      #default = "socks5h://127.0.0.1:2081";
      #noProxy = "127.0.0.1,localhost,*.local";
    };
  };
}