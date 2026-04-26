{ inputs, pkgs, ...}:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    google-chrome
    home-manager

    amnezia-vpn
    amneziawg-go
    amneziawg-tools

    ntfs3g
    libsecret
    gnome-keyring

    linuxPackages.cpupower
    dunst
    libnotify

    # Bluetooth
    bluez
    bluez-tools

    docker-compose

    sops
    age

    # xwayland
    xwayland-satellite
    wl-clipboard-rs
    xclip
    xsel
    cliphist
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  nixpkgs.overlays = [
  (final: prev: {
    openldap = prev.openldap.overrideAttrs (old: {
      doCheck = false;
    });
  })
];
}
