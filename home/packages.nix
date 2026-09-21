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
    translate-shell # Translator
    moreutils
    psmisc
    lsof
    dnsutils
    file

    grim
    slurp
    swappy

    alacritty # Terminal
    kitty # 2nd terminal for yazi

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

    # RGB controller
    openrgb

    # Catppuccin
    catppuccin-kvantum
    catppuccin-kde

    # Social
    telegram-desktop

    # Code stuff
    jetbrains-toolbox
    insomnia
    lazydocker

    # Java
    visualvm
    eclipse-mat

    # JS
    nodejs
    # pnpm

    # Visual
    obs-studio

    # Gaming
    steam
    umu-launcher
    protontricks
    protonup-qt

    # https://github.com/NixOS/nixpkgs/issues/513245
    (lutris.override {
      # Intercept buildFHSEnv to modify target packages
      buildFHSEnv =
        args:
        pkgs.buildFHSEnv (
          args
          // {
            multiPkgs =
              envPkgs:
              let
                # Fetch original package list
                originalPkgs = args.multiPkgs envPkgs;

                # Disable tests for openldap
                customLdap = envPkgs.openldap.overrideAttrs (_: {
                  doCheck = false;
                });
              in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
          }
        );
    })

    # Cristalix launcher FHS environment (requires glibc 2.43)
    (pkgs.callPackage ../pkgs/cristalix-fhs { })
  ];
}
