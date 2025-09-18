{
  home.file = {
    ".config/wofi/config".source = ./config;
    ".config/wofi/style.css".source = ./style.css;
  };
  programs.wofi = {
    enable = true;
  };
}