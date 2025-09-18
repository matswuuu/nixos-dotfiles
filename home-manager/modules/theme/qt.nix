{ pkgs, ... }: 

{
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
  };
}