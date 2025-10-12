import QtQuick
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"

WrapperMouseArea {
    readonly property var theme: Themes.active

    property string simpleFormat: "HH:mm ddd dd MMM"
    property string fullFormat: "HH:mm:ss dddd dd/MM/yyyy"

    property string currentFormat: simpleFormat

    onClicked: {
        currentFormat = currentFormat == simpleFormat ? fullFormat : simpleFormat
    }

    WrapperRectangle {
        color: theme.backgroundColor
        radius: theme.borderRadius
        margin: theme.margin

        Row {
            SystemClock {
                id: sysClock
                precision: SystemClock.Seconds
            }

            StyledText {
                text: Qt.formatDateTime(sysClock.date, currentFormat)
            }
        }
    }
}
