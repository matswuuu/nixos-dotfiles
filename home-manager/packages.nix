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
        mtpfs
        libmtp
        gvfs
        usbutils
        upower
        playerctl
        jq
        unzip
        shadowsocks-libev
        overskride # Bluetooth manager
        coolercontrol.coolercontrol-gui # Fan controller
        yt-dlp

        (flameshot.override { enableWlrSupport = true; })
        
        gtk3
        gtk4
        adw-gtk3

        # Qt
        # qt6.full      
        
        qt5.qtbase
        qt5.qtdeclarative
        qt5.qtquickcontrols
        qt5.qtcharts
        # qt6Packages.qt6ct
        # qt6Packages.qtbase
        # qt6Packages.qtdeclarative
        # qt6Packages.qtmultimedia
        # qt6Packages.qtsvg
        # qt6Packages.qtcharts

        # Dolphin
        kdePackages.dolphin
        kdePackages.kio-extras

        # Wayland
        wofi
        mpv
        mpvpaper
        hyprpaper
        hyprshot
        hyprsysteminfo
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

        # Visual
        krita
        blockbench
        figma-linux

        # Java
        recaf-launcher

        # JS
        nodejs

        # Python
        uv
        python312

        # Gaming
        steam
        protontricks
        mangohud
        protonup-qt
        lutris
        #modrinth-app # Minecraft

        # Anime
        ani-cli
    ];
}