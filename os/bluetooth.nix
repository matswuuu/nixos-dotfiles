{ pkgs }:
{
  hardware = {
    bluetooth = {
      enable = true;
    };
    blueman = {
      enable = true;
    };
  };
  services.blueman = {
    enable = true;
  };

  # Enable headset buttons control
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}