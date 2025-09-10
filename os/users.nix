{ pkgs, ... }:

{
  users = {
    mutableUsers = true;
    users.matswuuu = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
         "networkmanager" 
         "wheel"
      ];
    };
  };
}