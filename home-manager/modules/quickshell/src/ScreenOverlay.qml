import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/media/"
import "./utils/"

PanelWindow {
    id: overlay
    color: "transparent"
    implicitWidth: layout.width
    implicitHeight: layout.height
    anchors {
        top: true
    }
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
        id: layout
        spacing: 10
        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        VolumeIndicator {
            
        }

        BrightnessIndicator {
            
        }
    }
}