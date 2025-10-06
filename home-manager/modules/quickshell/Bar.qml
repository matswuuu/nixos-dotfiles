import "./utils/"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
  id: root

  property string time

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      color: "red"

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      ClockWidget {
        anchors.centerIn: parent
        time: root.time
      }

      Text {
        id: cpuText
        text: Formatter.formatKBtoGB(CpuUsage.cpuUsage)
      }

      Text {
        id: memoryText
        text: Formatter.formatKBtoGB(MemoryUsage.memoryUsed)
      }

      Item {
        RowLayout {
          spacing: 8
          Text {
            text: "123"
          }
          Text {
            text: "123"
          }

          Resource {
            
          }
        }
      }
    }
  }

  Process {
    id: dateProc
    command: ["date"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      dateProc.running = true

    }
  }
}