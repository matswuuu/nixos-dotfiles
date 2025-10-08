import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./../utils/"

WrapperRectangle {
    readonly property var theme: Themes.active
    property string format: "HH:mm ddd dd MMM"

    id: root
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        spacing: 8

        MprisWidget {

        }

        RowLayout {
            spacing: 4
            StyledText {
                text: Sound.getOutputSymbol()
            }
            StyledText {
                text: Sound.getInputSymbol()
            }
        }
    }
}
