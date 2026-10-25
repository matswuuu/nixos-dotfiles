{
  # OpenTabletDriver: userspace tablet driver with a GUI (`otd-gui`) and CLI
  # (`otd`) for configuring area mapping, pen pressure and express keys.
  # Works on Wayland (niri) since it emits input through uinput, so it needs
  # no DE-specific tablet settings panel. Supports Wacom Bamboo models.
  hardware.opentabletdriver = {
    enable = true;
    # Runs the driver as a systemd user service so settings apply on login.
    daemon.enable = true;
    # The module blacklists the `wacom` and `hid-uclogic` kernel drivers by
    # default so they don't grab the device before OpenTabletDriver does.
  };
}
