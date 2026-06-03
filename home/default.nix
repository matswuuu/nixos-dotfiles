{ pkgs, username, ... }:

{
  imports = [
    ./packages.nix
    ./cursor.nix
    ./modules/alacritty/default.nix
    ./modules/bar/default.nix
    ./modules/cliphist/default.nix
    ./modules/fastfetch/default.nix
    ./modules/wofi/default.nix
    ./modules/java/default.nix
    ./modules/btop/default.nix
    ./modules/yazi/default.nix
    ./modules/zed/default.nix
    ./modules/niri/default.nix
    ./modules/python/default.nix
    ./modules/theme/gtk.nix
    ./modules/theme/qt.nix
    ./modules/theme/catppuccin.nix
    ./modules/sops/default.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  xdg.desktopEntries.chrome-office = {
    name = "Google Chrome Office";
    exec = "/run/current-system/sw/bin/google-chrome-stable %U";
    icon = "google-chrome";
    terminal = false;
    noDisplay = true;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "application/msword"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ];
  };
}
