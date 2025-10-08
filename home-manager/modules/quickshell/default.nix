{ pkgs, ... }: 

{
  home.file = {
    ".config/quickshell/" = {
      source = ./src;
      recursive = true;
    };
  };
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
  };
}