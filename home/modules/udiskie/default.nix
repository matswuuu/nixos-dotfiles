{ pkgs, ... }:
{
  # Auto-mount removable USB storage via udisks2.
  # Requires services.udisks2.enable = true on the system side
  # (see nixos/services/udisk.nix).
  #
  # - mounts to /run/media/$USER/<label> on insert
  # - unmounts + cleans up on remove
  # - libnotify popups via dunst (systemPackages has libnotify + dunst)
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    # mtsw-bar has a tray; "auto" shows the icon only when a device is present.
    tray = "auto";
  };
}
