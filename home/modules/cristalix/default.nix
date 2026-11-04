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

  # The bundled GLFW prefers Wayland, where scroll arrives as fractional offsets
  # that the LWJGL2 compat layer truncates to int, dropping most wheel events.
  # Under X11 (xwayland-satellite) each notch is a whole ±1 step.
  cristalix = pkgs.writeShellScriptBin "cristalix" ''
    unset WAYLAND_DISPLAY
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:${lib.makeLibraryPath libs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec java -jar "''${1:-$HOME/Downloads/CristalixLauncher.jar}"
  '';
in
{
  home.packages = [ cristalix ];
}
