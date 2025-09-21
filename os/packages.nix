{ pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
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

    linuxPackages.cpupower

    # Bluetooth
    bluez
    bluez-tools

    coolercontrol.coolercontrold

    docker-compose

    xwayland
    wl-clipboard-rs
    xclip
    xsel
    cliphist
    
    # TODO: Move packages to module (file)
    nvtopPackages.nvidia
    vulkan-tools
  ];
  #  ++ (vars.profiles.${vars.activeProfile}.packages pkgs or []);
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}