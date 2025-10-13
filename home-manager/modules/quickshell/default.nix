{ pkgs, lib, ... }: 
  let
    qt6 = pkgs.qt6Packages;
    kde = pkgs.kdePackages;
  in
{
  home = {
    file = {
      ".config/quickshell/" = {
        source = ./src;
        recursive = true;
      };
    };
    sessionVariables = {
      # QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
      #   # pkgs.qt6.full
      #   # # qt6.qtbase
      #   # # qt6.qtdeclarative
      #   # # qt6.qtmultimedia
      #   # # qt6.qtsvg
      #   # qt6.qtcharts


      #   kde.qtbase
      #   kde.qtdeclarative
      #   kde.qtmultimedia
      #   kde.qtcharts
      # ];
      # QT_PLUGIN_PATH = lib.makeSearchPath "lib/qt-6/plugins" [
      #   # pkgs.qt6.full
      #   # qt6.qtcharts
      #   kde.qtbase
      #   kde.qtdeclarative
      #   kde.qtmultimedia
      #   kde.qtcharts
      # ];
    };
  };

  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;
  };
}