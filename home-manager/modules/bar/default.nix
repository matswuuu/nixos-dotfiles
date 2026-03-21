{
  programs.mtsw-bar = {
    enable = true;
    settings = {
      monitors = [ "DP-1" "eDP-1" ];
      bar = {
        tray = {
          iconOrder = [
              "chrome_status_icon_1" # Discord
              "telegram"
          ];
        };
      };
    };
  };
}