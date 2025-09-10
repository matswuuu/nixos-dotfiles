{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
    hyprland
    kitty
    waybar
    google-chrome
    home-manager
    amnezia-vpn
    ntfs3g
    libsecret
    gnome-keyring
    kdePackages.kwallet

    docker-compose

    xwayland
    wl-clipboard-rs
    xclip
    xsel
    cliphist
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}