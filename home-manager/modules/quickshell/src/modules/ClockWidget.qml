import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./calendar/"

StyledPopup {
    readonly property var theme: Themes.active

    property string simpleFormat: "HH:mm ddd dd MMM"
    property string fullFormat: "HH:mm:ss dddd dd/MM/yyyy"

    property string currentFormat: simpleFormat

    contentItem: CalendarWidget {
        id: calendar
    }

    onEntered: {
        calendar.monthOffset = 0
    }
    onClicked: {
        currentFormat = currentFormat == simpleFormat ? fullFormat : simpleFormat;
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