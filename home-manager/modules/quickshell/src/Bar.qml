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

PanelWindow {
  id: root
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

  readonly property var theme: Themes.active

  RowLayout {
    id: leftLayout
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
    }

    ResourceBlock {

    }

    // MprisWidget {
      
    // }
  }

  RowLayout {
    anchors {
      centerIn: parent
    }

    ClockWidget {
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