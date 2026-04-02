{ pkgs, ... }:
{
    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
        # Cursor 
        numix-cursor-theme

        # Utils
        brightnessctl
        fastfetch
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
        yt-dlp
        ffmpeg
        gcc
        ripgrep
        ncdu # cli disk analyzer
        pwgen # cli password generator
        mpv # video player
        speedtest-cli # Internet speed test
        sshpass # Non-interactive ssh password auth

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
        wl-clipboard
        cliphist

        # Wallpaper
        mpvpaper
        swww

        # Catppuccin
        catppuccin-kvantum
        catppuccin-kde

        # Social
        telegram-desktop
        #discord-ptb

        # Code stuff
        vscode
        jetbrains-toolbox 
        mongodb-compass
        insomnia
        awscli2

        # Java
        visualvm

        # JS
        nodejs

        # Python
        python3
        uv
        conda

        # AI
        claude-code

        # Visual
        #krita
        blockbench
        obs-studio

        # Gaming
        steam
        protontricks
        mangohud
        protonup-qt
        lutris
    ];
}
