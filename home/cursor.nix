{ pkgs, ... }: 

{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    size = 24;
  };
}