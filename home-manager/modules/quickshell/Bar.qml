import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import "./element/"
import "./utils/"
import "./theme/"
import "./modules/"

Scope {
  id: root

  readonly property var theme: Themes.active
  property string time

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

      Clock {
        anchors.centerIn: parent
        // time: root.time
      }

      RowLayout {
        id: leftLayout

        WrapperRectangle {
          id: resourcesLayout
          color: theme.backgroundColor
          radius: theme.borderRadius
          margin: theme.margin

          RowLayout {
            spacing: 8

            RowLayout {
              spacing: 4

              StyledText {
                text: "CPU"
              }
              StyledText {
                text: Formatter.formatKBtoGB(CpuUsage.cpuUsage)
              }
            }

            RowLayout {
              spacing: 4

              StyledText {
                text: "GPU"
              }
              StyledText {
                text: Formatter.formatKBtoGB(CpuUsage.cpuUsage)
              }
            }

            StyledText {
              text: Formatter.formatKBtoGB(MemoryUsage.memoryUsed) + "G"
            }
          }
        }
      }

      RowLayout {
        id: rightLayout
        anchors {
          right: parent.right
          rightMargin: 55
        }
      
        Tray {
          id: tray
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