import QtQuick
import Quickshell
import "./modules/media/"

ShellRoot {
  property list<string> monitors: ["DP-1", "eDP-1"]

  Scope {
    id: root

    Variants {
      model: [
        Quickshell.screens.filter(monitor => monitors.includes(monitor.name))
      ]

      Bar {
        id: bar
      }
    }
  }

  // MediaWindow {}
}