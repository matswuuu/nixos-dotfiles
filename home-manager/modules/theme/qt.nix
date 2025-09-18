{ pkgs, ... }: 

{
  qt = {
    enable = true;
    platformTheme = {
      name = "kvantum";
    };
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
  };
}