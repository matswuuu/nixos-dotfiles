{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "matswuuu";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
