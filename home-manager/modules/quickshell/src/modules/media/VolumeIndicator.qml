import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../utils/"

DisplayIndicator {
    id: soundIndicator
    Layout.alignment: Qt.AlignHCenter
    title: "Volume"
    icon: Sound.getOutputSymbol()

    Connections {
        target: Sound

        function onOutputUpdated(volume: int, muted: bool) {
            soundIndicator.value = volume;
            soundIndicator.icon = Sound.getOutputSymbol();
            soundIndicator.show();
        }
    }
}