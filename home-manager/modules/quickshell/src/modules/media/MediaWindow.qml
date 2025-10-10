import QtQuick
import QtQuick.Layouts
import QtQuick.Effects 
import Quickshell
import Quickshell.Widgets

PanelWindow {
    width: 400
    height: 400

    anchors {
        // left: true
        top: true
        // bottom: true
        right: true
    }

    Rectangle {
        width: 300
        height: 300
        radius: 25
        clip: true
        anchors.centerIn: parent

        Image {
            anchors.fill: parent
            source: "1.png"
        }

        // layer.enabled: true
        // layer.effect: OpacityMask {
        //     maskSource: Rectangle {
        //         width: parent.width
        //         height: parent.height
        //         radius: 25    // smooth, anti-aliased corners
        //     }
        // }
    }
}