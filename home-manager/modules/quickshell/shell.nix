# { pkgs ? import <nixpkgs> {} }:

# let
#   qtModules = [
#     pkgs.qt6.full
#     pkgs.qt6.qtcharts
#   ];
#   paths = pkgs.lib.makeSearchPath "lib/qt-6/qml" [
#     pkgs.qt6.full
#     # pkgs.qt6.qtcharts
#   ];
# in

# pkgs.mkShell {
#   buildInputs = qtModules ++ [ pkgs.quickshell ];
#   shellHook = ''
#     # export QML2_IMPORT_PATH=${paths}
#     # export QT_QML_IMPORT_PATH=${paths}
#     echo "QuickShell ready with Qt6 and QtCharts"
#     echo "QML paths:"
#     echo $QML2_IMPORT_PATH
#   '';
# }



# { pkgs ? import <nixpkgs> {} }:

# let
#   # Qt6 packages we need
#   qtModules = [
#     pkgs.qt6.full       # full Qt6 with all QML modules
#     # pkgs.qt6.qtcharts   # QtCharts C++ library
#   ];

#   # Automatically construct colon-separated QML paths
#   qmlPaths = pkgs.lib.makeSearchPath "lib/qt-6/qml" qtModules
#            + ":" + pkgs.lib.makeSearchPath "share/qml" qtModules;
# in

# pkgs.mkShell {
#   buildInputs = qtModules ++ [ pkgs.quickshell ];

#   shellHook = ''
#     export QML2_IMPORT_PATH=${qmlPaths}
#     export QT_QML_IMPORT_PATH=${qmlPaths}
#     echo "QuickShell ready with Qt6 and QtCharts"
#     echo "QML paths:"
#     echo $QML2_IMPORT_PATH
#   '';
# }






{ pkgs ? import <nixpkgs> {} }:

let
  qtCores = [
    pkgs.qt6.full       # contains all QML modules including QtCharts
    pkgs.qt6.datavisualization   # C++ library
  ];

  # Only include qt6.full for QML
  qmlPaths = pkgs.lib.makeSearchPath "lib/qt6/qml" [ pkgs.qt6.full ]
           + ":" + pkgs.lib.makeSearchPath "share/qml" [ pkgs.qt6.full ];
in

pkgs.mkShell {
  buildInputs = qtCores ++ [ pkgs.quickshell ];

  shellHook = ''
    export QML2_IMPORT_PATH=${qmlPaths}
    echo "QuickShell ready with Qt6 and QtCharts"
    echo "QML paths:"
    echo $QML2_IMPORT_PATH
  '';
}
