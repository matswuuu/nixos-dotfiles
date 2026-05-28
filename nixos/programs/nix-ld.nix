{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      libdrm
      libgbm
      libsecret
      libxkbcommon
      mesa
      nspr
      nss
      pango
      wayland
      libice
      libsm
      libx11
      libxcb
      libxcursor
      libxext
      libxi
      libxinerama
      libxrandr
      libxrender
      libxtst
      zlib
    ];
  };
}
