import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./../utils/"

StyledPopup {
    readonly property var theme: Themes.active

    contentItem: WrapperRectangle {
        color: theme.backgroundColor2
        radius: theme.borderRadius
        margin: theme.margin

        ColumnLayout {
            spacing: 4
            
        }
    }

    StyledText {
        text: Bluetooth.stateSymbol
    }
}