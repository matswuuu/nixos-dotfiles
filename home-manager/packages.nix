{ pkgs, ... }:
{
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
        # Cursor 
        numix-cursor-theme

        # Utils
        brightnessctl
        screenfetch
        htop
        lm_sensors
        wget
        git
        file-roller
        sshuttle
        traceroute
        mtr
        jmtpfs
        simple-mtpfs
        # mtpfs
        libmtp
        gvfs
        usbutils
        upower
        playerctl
        jq
        unzip
        overskride # Bluetooth manager
        coolercontrol.coolercontrol-gui # Fan controller
        yt-dlp
        ffmpeg
        gcc
        btop

        grimblast
        grim
        slurp
        swappy

        gtk3
        gtk4
        adw-gtk3

        # Qt
        qt6.qtdeclarative

        # Dolphin
        kdePackages.dolphin
        kdePackages.kio-extras

        # Wayland
        wofi
        mpv
        mpvpaper
        hyprpaper
        hyprshot
        hyprpicker
        hyprlauncher
        wl-clipboard
        cliphist
        obs-studio
        wayvnc
        tigervnc

        # Catppuccin
        catppuccin-kvantum
        catppuccin-kde

        # Social
        telegram-desktop
        discord-ptb

        # Code stuff
        vscode
        jetbrains-toolbox 
        mongodb-compass
        insomnia
        eclipse-mat
        visualvm

        # Visual
        krita
        blockbench
        figma-linux
        blender

        # JS
        nodejs

        # Python
        uv
        conda
        (python3.withPackages (ps: with ps; [
          tkinter
        ]))

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
