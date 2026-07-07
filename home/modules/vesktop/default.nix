{ config, lib, pkgs, ... }:

let
  # Discover all plugin files in ./plugins/ (skip hidden files like .gitkeep)
#  pluginFiles = builtins.readDir ./plugins;
#  pluginEntries = lib.filterAttrs (name: _type: _type == "regular" && !lib.hasPrefix "." name) pluginFiles;
#
#  # Discover all theme files in ./themes/ (skip hidden files like .gitkeep)
#  themeFiles = builtins.readDir ./themes;
#  themeEntries = lib.filterAttrs (name: _type: _type == "regular" && !lib.hasPrefix "." name) themeFiles;
#
#  # Build home.file entries for plugins
#  mkPluginEntry = name: {
#    ".config/vesktop/plugins/${name}" = {
#      source = ./plugins/${name};
#      force = true;
#    };
#  };
#
#  # Build home.file entries for themes
#  mkThemeEntry = name: {
#    ".config/vesktop/themes/${name}" = {
#      source = ./themes/${name};
#      force = true;
#    };
#  };

  # Compiled third-party plugins fetched from GitHub
#  removeChildishChannelNames = pkgs.stdenv.mkDerivation {
#    name = "vc-removeChildishChannelNames";
#    src = pkgs.fetchFromGitHub {
#      owner = "matswuuu";
#      repo = "vc-removeChildishChannelNames";
#      rev = "d2c609ed22a78a9df37425c620158947e4fe5497";
#      hash = "sha256-19czKqxBoRGXS63wqCpz3Yh1b8VdmRu3pkv/TTlyFJg=";
#    };
#    buildInputs = [ pkgs.esbuild ];
#    buildPhase = ''
#      esbuild index.tsx --bundle --outfile=index.js \
#        --external:@api/* --external:@components/* \
#        --external:@utils/* --external:@vencord/* \
#        --external:@webpack/* \
#        --format=esm --platform=browser
#    '';
#    installPhase = "cp index.js $out/";
#  };
in
{
#  home.file = {
#    # Vesktop app settings
#    ".config/vesktop/settings.json" = {
#      source = ./settings.json;
#      force = true;
#    };
#
#    # Vencord plugin configuration (which plugins are enabled/disabled)
#    ".config/vesktop/settings/settings.json" = {
#      source = ./vencord-settings.json;
#      force = true;
#    };
#
#    # Quick CSS
#    ".config/vesktop/settings/quickCss.css" = {
#      source = ./quickCss.css;
#      force = true;
#    };
#
#    # removeChildishChannelNames plugin
##    ".config/vesktop/plugins/removeChildishChannelNames.js" = {
##      source = "${removeChildishChannelNames}/index.js";
##      force = true;
##    };
#  }
#  // builtns.foldl' (acc: e: acc // (mkPluginEntry e.name)) {} (builtins.attrValues pluginEntries)
#  // builtins.foldl' (acc: e: acc // (mkThemeEntry e.name)) {} (builtins.attrValues themeEntries);
}
