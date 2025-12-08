{ pkgs, ... }:
{
    nixpkgs.config.allowUnfree = true;
    # TODO: Remove
    nixpkgs.config.permittedInsecurePackages = [
      "gradle-7.6.6"
    ];
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
        overskride # Bluetooth manager
        coolercontrol.coolercontrol-gui # Fan controller
        yt-dlp
        ffmpeg
        gcc

        (flameshot.override { enableWlrSupport = true; })
        
        gtk3
        gtk4
        adw-gtk3

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
        code-cursor
        jetbrains-toolbox 
        #mongodb-compass
        insomnia

        # Visual
        krita
        blockbench
        figma-linux

        # JS
        nodejs

        # Python
        uv
        conda
        portaudio
        python3Packages.dbus-python
        (python3.withPackages (ps: with ps; [
          tkinter
          dbus-python
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
