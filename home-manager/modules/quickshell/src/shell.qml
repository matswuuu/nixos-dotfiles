import QtQuick
import QtQuick.Layouts
import Quickshell
import "./element/"

ShellRoot {
  property list<string> monitors: ["DP-1", "eDP-1"]

  Variants {
    model: Quickshell.screens.filter(monitor => monitors.includes(monitor.name))

    Scope {
      required property var modelData

      Bar {
        id: bar
        screen: modelData
      }

      ScreenOverlay {
        screen: modelData
        margins {
          top: bar.margins.top * 2 + bar.height
        }
      }
    }   
  }
}