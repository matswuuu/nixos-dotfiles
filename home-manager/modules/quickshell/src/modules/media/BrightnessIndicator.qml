import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../utils/"

DisplayIndicator {
    id: brightnessIndicator
    Layout.alignment: Qt.AlignHCenter
    title: "Brightness"
    icon: Brightness.getSymbol()

    Connections {
        target: Brightness

        function onBrightnessChanged(currentBrightness, maxBrightness) {
            brightnessIndicator.value = Math.floor(currentBrightness / maxBrightness * 100);
            brightnessIndicator.icon = Brightness.getSymbol();
            brightnessIndicator.show();
        }
    }
}
