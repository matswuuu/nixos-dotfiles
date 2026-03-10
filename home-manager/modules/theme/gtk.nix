{ inputs, lib, config, pkgs, ...}:
{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
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