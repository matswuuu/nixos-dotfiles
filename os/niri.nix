{ pkgs, ...}:
{
#   services = {
#     xserver.xkb = {
#       layout = "us,ru";
#       variant = "";
#     };
#     seatd = {
#       enable = true;
#     };
#     dbus = {
#       enable = true;
#     };
#   };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "x-directory/normal" = [ "org.kde.dolphin.desktop" ];
      };
    };
  };

  programs.niri = {
    enable = true;
  };
}