{ pkgs, lib, ... }:

let
  # The game's bundled LWJGL natives dlopen libGL.so.1, which NixOS doesn't expose
  # (nix-ld only has the mesa vendor libs), so GL.create fails with
  # "There is no OpenGL context management API available".
  libs = with pkgs; [
    libGL
    libpulseaudio
    alsa-lib
    libx11
    libxcursor
    libxrandr
    libxxf86vm
    libxi
    libxext
    libxkbcommon
    wayland
    udev
  ];

  cristalix = pkgs.writeShellScriptBin "cristalix" ''
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:${lib.makeLibraryPath libs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec java -jar "''${1:-$HOME/Downloads/CristalixLauncher.jar}"
  '';
in
{
  home.packages = [ cristalix ];
}
