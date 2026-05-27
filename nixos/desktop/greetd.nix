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
