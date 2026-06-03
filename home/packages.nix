{ pkgs, ... }:
{
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
        jq # Json parser
        jc # Json parser
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
        iptables
        nftables
        tcpdump
        ydotool # Clicker
        translate-shell # Translator

        grimblast
        grim
        slurp
        swappy

        whisper-cpp-vulkan
        voxtype-vulkan
        
        gtk3
        gtk4
        adw-gtk3

        # Qt
        qt6.qtdeclarative

        # Wayland
        wofi
        wl-clipboard
        cliphist

        # Wallpaper
        mpvpaper
        awww

        # Catppuccin
        catppuccin-kvantum
        catppuccin-kde

        # Social
        telegram-desktop
        #discord-ptb
        vesktop

        # Code stuff
        vscode
        jetbrains-toolbox 
        mongodb-compass
        insomnia

        # Java
        visualvm
        eclipse-mat

        # JS
        nodejs
        pnpm

        # AI
        claude-code
        antigravity

        # Visual
        #krita
        blockbench
        obs-studio

        # Gaming
        steam
        protontricks
        mangohud
        protonup-qt

        # https://github.com/NixOS/nixpkgs/issues/513245
        (lutris.override {
          # Intercept buildFHSEnv to modify target packages
          buildFHSEnv = args: pkgs.buildFHSEnv (args // {
            multiPkgs = envPkgs:
              let
                # Fetch original package list
                originalPkgs = args.multiPkgs envPkgs;

                # Disable tests for openldap
                customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
              in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
          });
        })
  ];
}
