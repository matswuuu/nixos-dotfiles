{ ... }:
{
  # KDE Connect daemon + indicator (useful outside Plasma, e.g. Niri tray).
  # NixOS side enables the program/firewall via programs.kdeconnect.
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
