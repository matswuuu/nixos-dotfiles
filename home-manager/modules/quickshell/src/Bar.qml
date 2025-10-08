import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import "./element/"
import "./utils/"
import "./theme/"
import "./modules/"
import "./modules/resource/"

Scope {
  id: root

  readonly property var theme: Themes.active

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      color: "transparent"
      anchors {
        top: true
        left: true
        right: true
      }
      margins {
        left: 10
        right: 10
        top: 6
      }
      implicitHeight: 32

      RowLayout {
        id: leftLayout
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
        }

        ResourceBlock {

        }

        MprisWidget {
          
        }
      }

      RowLayout {
        anchors {
          centerIn: parent
        }

        Clock {
        }
      }

      RowLayout {
        id: rightLayout
        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
        }

        SoundWidget {
          
        }

        System {
          
        }

        Tray {

        }
      }
    }
  }
}