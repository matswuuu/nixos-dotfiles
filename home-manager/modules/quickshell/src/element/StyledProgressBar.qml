import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ProgressBar {
    id: control
    implicitHeight: 4
    // Material.theme: Material.Light
    // Material.accent: "#6750A4" // Material 3 default purple

    background: Rectangle {
        implicitHeight: control.implicitHeight
        radius: height / 2
        color: Qt.rgba(Material.accent.r, Material.accent.g, Material.accent.b, 0.24)
    }

    contentItem: Item {
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            height: control.implicitHeight
            radius: height / 2
            width: control.indeterminate
                   ? parent.width * 0.3
                   : control.visualPosition * parent.width
            x: control.indeterminate ? animX : 0
            color: Material.accent

            Behavior on width {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }

            property real animX: 0
            SequentialAnimation on animX {
                running: control.indeterminate
                loops: Animation.Infinite
                NumberAnimation {
                    from: -width
                    to: parent.width
                    duration: 1200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
