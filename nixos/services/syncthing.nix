{ config, inputs, username, ... }:

{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets.yaml";
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets."syncthing/gui_password" = {
      owner = username;
    };
  };

  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Sync";
    configDir = "/home/${username}/.config/syncthing";
    openDefaultPorts = true;
    guiPasswordFile = config.sops.secrets."syncthing/gui_password".path;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      gui.user = username;

      devices = {
        peer = {
          id = "D3VZM5S-4BM33TO-AA7VK6A-QRLGC67-RT2QRIF-CA4ULRP-ZDN6ZZG-VKIAFQG";
        };
      };

      folders = {
        "obsidian-work" = {
          path = "/home/${username}/Documents/Obsidian/Work";
          devices = [ "peer" ];
        };
        "obsidian-personal" = {
          path = "/home/${username}/Documents/Obsidian/Personal";
          devices = [ "peer" ];
        };
        "school" = {
          path = "/home/${username}/Documents/school";
          devices = [ "peer" ];
        };
      };
    };
  };
}
