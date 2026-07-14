{ pkgs, lib, ... }:
let
  vars = import ./../../../vars.nix;

  scrolloverview-plugin = pkgs.hyprlandPlugins.mkHyprlandPlugin {
    pluginName = "hyprland-scroll-overview";
    pname = "hyprland-scroll-overview";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
      owner = "yayuuu";
      repo = "hyprland-scroll-overview";
      rev = "8b6d2b6943f82067febc4ecd6b4a73cb9bf8b3ba";
      sha256 = "1mppf2skfm1rm52y2yq9nbbzlivglw8hkkzcnwbvn7zg3ab4jkg4";
    };

    buildInputs = [
      pkgs.pixman
      pkgs.libdrm
      pkgs.pango
      pkgs.libinput
      pkgs.udev
      pkgs.wayland
      pkgs.libxkbcommon
      pkgs.lua5_5
    ];

    nativeBuildInputs = [ pkgs.gcc14 ];

    buildPhase = ''
      sed -i 's/lua5\.4/lua5.5/' Makefile
      make all
    '';

    installPhase = ''
      mkdir -p "$out/lib"
      cp scrolloverview.so "$out/lib/libscrolloverview.so"
    '';

    meta = {
      description = "Scrollable overview plugin for Hyprland";
      homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ ];
    };
  };
in
{
  home.file = {
    ".config/awww/wallpapers" = {
      source = ../niri/wallpapers;
      recursive = true;
    };
    ".config/hypr/common.lua".source = ./common.lua;
    ".config/hypr/binds.lua".source = ./binds.lua;
    ".config/hypr/env.lua".source = ./env.lua;
    ".config/hypr/monitor.lua".source = ./monitor.lua;
    ".config/hypr/hyprland.lua".source = ./hyprland.lua;
    ".config/hypr/plugin.lua".text = ''
      -- Load plugin at top-level (works for hyprctl reload when socket is ready)
      hl.exec_cmd("hyprctl plugin load ${scrolloverview-plugin}/lib/libscrolloverview.so")

      -- Load plugin at startup (works at boot when hyprctl socket isn't ready yet)
      hl.on("hyprland.start", function()
          hl.exec_cmd("hyprctl plugin load ${scrolloverview-plugin}/lib/libscrolloverview.so")
      end)

      -- Only configure and set up gesture when plugin is loaded
      if hl.plugin.scrolloverview ~= nil then
          hl.config({
              plugin = {
                  scrolloverview = {
                      gesture_distance = 200,
                      scale = 0.5,
                      workspace_gap = 0,
                      layout = "vertical",
                      wallpaper = 0,
                      blur = false,
                      shadow = {
                          enabled = false,
                      },
                  },
              },
          })
          hl.plugin.scrolloverview.gesture({ fingers = 3, direction = "vertical" })
      end
    '';
  };
  home.packages = [ scrolloverview-plugin ];
}