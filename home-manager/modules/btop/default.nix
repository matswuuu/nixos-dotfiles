{ pkgs, ... }: 
{
  programs.btop = {
    enable = true;
    package = pkgs.btop;
    # catppuccin = {
    #   enable = true;
    #   flavor = "macchiato";
    # };

    # settings = {
    #   color_theme = "catppuccin_macchiato";
    # };
  };
}
