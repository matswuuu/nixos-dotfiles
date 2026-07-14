{ pkgs, username, ... }:

let
  niriSession = "${pkgs.niri}/bin/niri-session";
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = niriSession;
        user = username;
      };
      default_session = {
        command = niriSession;
        user = username;
      };
    };
  };
}
#{ pkgs, username, ... }:
#
#let
#  hyprlandSession = "${pkgs.uwsm}/bin/uwsm start hyprland.desktop";
#in
#{
#  services.greetd = {
#    enable = true;
#    settings = {
#      initial_session = {
#        command = hyprlandSession;
#        user = username;
#      };
#      default_session = {
#        command = hyprlandSession;
#        user = username;
#      };
#    };
#  };
#}
