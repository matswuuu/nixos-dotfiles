{ inputs, pkgs, ...}:
  let
    vars = import ./../vars.nix;
  in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    hyprland
    kitty
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