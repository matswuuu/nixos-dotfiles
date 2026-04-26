{ inputs, lib, config, pkgs, ...}:
{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.theme = config.gtk.theme;
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
  	    color-scheme = "prefer-dark";
      };
    };
  };
}