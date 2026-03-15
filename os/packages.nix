{ inputs, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    google-chrome
    home-manager
    amnezia-vpn
    ntfs3g
    libsecret
    gnome-keyring
    kdePackages.kwallet

    linuxPackages.cpupower
    dunst
    libnotify

    # Bluetooth
    bluez
    bluez-tools

    coolercontrol.coolercontrold

    docker-compose

    # xwayland
    xwayland-satellite
    wl-clipboard-rs
    xclip
    xsel
    cliphist

    catppuccin-sddm
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
}
