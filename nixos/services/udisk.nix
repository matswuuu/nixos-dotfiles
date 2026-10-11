{ pkgs, ... }:
{
  services.udisks2 = {
    enable = true;
  };

  # MTP / PTP / volume monitoring for file managers + `gio mount mtp://...`
  # Required for Android phones over USB (File Transfer mode).
  services.gvfs = {
    enable = true;
  };

  # libmtp udev rules so MTP devices get correct permissions / uaccess tags.
  # (android-udev-rules was removed upstream; systemd >= 258 handles
  # Android uaccess automatically, libmtp covers MTP.)
  services.udev.packages = with pkgs; [
    libmtp.out
  ];

  # Needed for go-mtpfs / FUSE-based MTP mounts (allow_other).
  # adb itself needs no NixOS option anymore (systemd uaccess handles it);
  # the adb/fastboot binaries come from home.packages (android-tools).
  programs.fuse.userAllowOther = true;

  # udisks2 mounts need polkit auth. On a minimal WM (niri, no DE agent),
  # allow wheel to mount/unlock without a password prompt while still
  # requiring an active local session for others.
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel") &&
            (action.id.indexOf("org.freedesktop.udisks2.") == 0)) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
