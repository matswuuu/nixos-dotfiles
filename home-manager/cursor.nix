{ pkgs, ... }: 

{
  home.file.".icons/default".source = "${pkgs.numix-cursor-theme}/share/icons/numix";
}