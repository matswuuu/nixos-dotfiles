{ inputs, pkgs, ...}:
{
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    permittedInsecurePackages = [
      "openssl-1.1.1w"
      "pnpm-10.29.2"
    ];
  };
  
  environment.systemPackages = with pkgs; [
    google-chrome
    home-manager

    amnezia-vpn
    amneziawg-go
    amneziawg-tools
    sing-box

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
}
