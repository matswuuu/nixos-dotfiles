{ pkgs, username, ... }:

{
  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager" 
        "wheel"
        "docker"
        "dialout"
        "input"
      ];
    };
  };
}
