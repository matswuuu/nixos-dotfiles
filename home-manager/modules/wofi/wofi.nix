{
  home.file = {
    ".config/wofi/config".source = ./config;
    ".config/wofi/style.css".source = ./style.css;
  };
  programs.wofi = {
    enable = true;
    # settings = {
    #   mode = "drun";
    #   show-icons = true;
    #   drun-icon-size = 64;
    #   width = "25%";
    # };
  };
}