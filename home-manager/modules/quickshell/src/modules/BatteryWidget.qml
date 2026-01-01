import QtQml.Models
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "./../element/"
import "./../theme/"
import "./../utils/"

StyledPopup {
    readonly property var theme: Themes.active

    property var device: Battery.device
    property string timeToEmpty: `Time to empty: ${Formatter.formatTime(device.timeToEmpty)}`
    property string timeToFull: `Time to full: ${Formatter.formatTime(device.timeToFull)}`
    property string energy: `Energy: ${device.energy.toFixed(0)}/${device.energyCapacity.toFixed(0)} Wh (${device.changeRate.toFixed(0)} W)`

    visible: Battery.present

    contentItem: WrapperRectangle {
        color: theme.backgroundColor2
        radius: theme.borderRadius
        margin: theme.margin + 4

        RowLayout {
            StyledText {
                text: [
                    ...(device.timeToEmpty > 0 ? [timeToEmpty] : []),
                    ...(device.timeToFull > 0 ? [timeToFull] : []),
                    energy
                ].join("\n")
            }
        }
    }

    StyledText {
        text: Battery.percentage + "%"
    }
}