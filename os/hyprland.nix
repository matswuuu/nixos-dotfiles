{ pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  services = {
    xserver.xkb = {
      layout = "us,ru";
      variant = "";
    };
    seatd = {
      enable = true;
    };
    dbus = {
      enable = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland 
      ];
    };
    mime = {
      enable = true;
<<<<<<< HEAD
      defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "x-directory/normal" = [ "org.kde.dolphin.desktop" ];
      };
    };
=======
    };
    # mimeApps = {
    #   enable = true;
    #   defaultApplications = {
    #     "inode/directory" = [ "org.kde.dolphin.desktop" ];
    #     "x-directory/normal" = [ "org.kde.dolphin.desktop" ];
    #   };
    # };
>>>>>>> 121b4dce4a05ce5cc3eed1e857f94318d6d8ac74
  };

  programs.hyprland = {
    enable = true;
  };
}