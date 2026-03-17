{ pkgs, ...}:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
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