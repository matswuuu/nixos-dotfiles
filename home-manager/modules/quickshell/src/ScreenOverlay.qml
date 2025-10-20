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

        DisplayIndicator {
            id: soundIndicator
            Layout.alignment: Qt.AlignHCenter
            title: "Volume"
            icon: Sound.getOutputSymbol()
        }

        DisplayIndicator {
            id: brightnessIndicator
            Layout.alignment: Qt.AlignHCenter
            title: "Brightness"
            icon: Brightness.getSymbol()
        }

        Connections {
            target: Sound

            function onOutputUpdated(volume: int, muted: bool) {
                soundIndicator.value = volume;
                soundIndicator.icon = Sound.getOutputSymbol();
                soundIndicator.show();
            }
        }

        Connections {
            target: Brightness

            function onBrightnessChanged(currentBrightness, maxBrightness) {
                brightnessIndicator.value = Math.floor(currentBrightness / maxBrightness * 100);
                brightnessIndicator.icon = Brightness.getSymbol();
                brightnessIndicator.show();
            }
        }
    }
}