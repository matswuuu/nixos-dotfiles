import Quickshell
import Quickshell.Io
import QtQuick

Item {
    Text {
        id: title
    }
    Text {
        id: percentUsage
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: tooltip.visible = true
        onExited: tooltip.visible = false
    }

    PopupWindow {
        id: tooltip
        visible: false
        flags: Qt.ToolTip | Qt.FramelessWindowHint
        anchors.centerIn: parent

        Rectangle {
            color: "#222"
            radius: 6
            border.color: "#555"
            padding: 6

            Label {
                text: "I am a tooltip!"
                color: "white"
            }
        }
    }
}