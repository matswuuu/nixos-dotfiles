import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
  }

  RowLayout {
    anchors {
      centerIn: parent
    }

    ClockWidget {
      id: clock

      // ToolTip {
      //   parent: clock
      //   visible: true
      //   text: "test"
      //   margins: 20

      //   contentItem: RowLayout {
      //     Text {
      //       text: "test"
      //       color: "#21be2b"
      //     }
      //   }

      //   background: Rectangle {
      //     border.color: "#21be2b"
      //     implicitHeight: 100
      //     implicitWidth: 400
      //   }
      // }
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