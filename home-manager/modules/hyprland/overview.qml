import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: overview
    anchors.fill: parent
    layer: Layer.Overlay
    keyboardMode: PanelWindow.Exclusive
    visible: true
    focus: true

    Rectangle {
        anchors.fill: parent
        color: "#AA000000"   // dim background

        GridView {
            id: grid
            anchors.centerIn: parent
            cellWidth: 320
            cellHeight: 200
            model: windowsModel

            delegate: Rectangle {
                width: 300
                height: 180
                radius: 12
                color: "#222"

                Text {
                    anchors.centerIn: parent
                    text: model.title
                    color: "white"
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Hyprland.focusWindow(model.address)
                        overview.visible = false
                    }
                }
            }
        }
    }
}
