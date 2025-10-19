import QtQuick
import Quickshell
import "./modules/media/"
import "./element/"

ShellRoot {
  property list<string> monitors: ["DP-1", "eDP-1"]

  FontLoader {
    id: iconFont
    source: "./fonts/MaterialIcons-Regular.ttf"
  }

  Scope {
    id: root

    Variants {
      model: Quickshell.screens.filter(monitor => monitors.includes(monitor.name))

      Bar {
        id: bar
      }
    }
  }
}