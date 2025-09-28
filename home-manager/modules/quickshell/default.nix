{ pkgs, ... }: 

{
  home.file = {
    ".config/quickshell/schell.qml".source = ./shell.qml;
  };
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
  };
}