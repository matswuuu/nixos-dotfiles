{ pkgs, ...}:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
    };
    mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "x-directory/normal" = [ "org.kde.dolphin.desktop" ];

        "application/msword" = [ "chrome-office.desktop" ];
        "application/vnd.ms-excel" = [ "chrome-office.desktop" ];
        "application/vnd.ms-powerpoint" = [ "chrome-office.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "chrome-office.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "chrome-office.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "chrome-office.desktop" ];
      };
    };
  };

  programs.niri = {
    enable = true;
  };
}
