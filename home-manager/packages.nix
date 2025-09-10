{ pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
        # Utils
        brightnessctl
        screenfetch
        htop
        lm_sensors
        wget
        git
        file-roller
        sshuttle
        upower
        playerctl
        jq
        unzip
        shadowsocks-libev

        (flameshot.override { enableWlrSupport = true; })
        
        gtk3

        # Dolphin
        kdePackages.dolphin
        kdePackages.qtsvg
        kdePackages.kio-extras

        # Wayland
        wofi
        mpv
        mpvpaper
        hyprshot
        wl-clipboard
        cliphist
        obs-studio

        # Wine
        wineWowPackages.stable
        lutris

        # Social
        telegram-desktop
        #discord

        # Code stuff
        vscode
        jetbrains-toolbox 
        python314
        recaf-launcher
        mongodb-compass
        insomnia
        blockbench
        figma-linux

        # Gaming
        steam
        protontricks
        mangohud
        protonup-qt
        lutris

        # Anime
        ani-cli
    ];
}