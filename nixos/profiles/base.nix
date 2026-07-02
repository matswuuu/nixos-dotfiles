{
  imports = [
    ../core/boot.nix
    ../core/dbus.nix
    ../core/gc.nix
    ../core/i18n.nix
    ../core/nix.nix
    ../core/packages.nix
    ../core/state-version.nix
    ../core/users.nix

    ../hardware/bluetooth.nix
    ../hardware/uinput.nix

    ../services/flatpak.nix
    ../services/openssh.nix
    ../services/security.nix
    ../services/sing-box
    ../services/udisk.nix
    ../services/upower.nix

    ../programs/amnezia/amnezia-vpn.nix
    ../programs/docker.nix
    ../programs/podman.nix
    ../programs/nix-ld.nix
    ../programs/shell.nix
    ../programs/ssh.nix
  ];
}
