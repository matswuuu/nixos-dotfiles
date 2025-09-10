{ pkgs, ...}:

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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland 
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  programs.hyprland = {
     enable = true;
  };
}