{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark"; # Replace with your desired theme name
      package = pkgs.libsForQt5.breeze-gtk; # Or your theme package
    };
  };
}