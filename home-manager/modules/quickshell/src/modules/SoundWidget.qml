import QtQuick
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"

WrapperRectangle {
    readonly property var theme: Themes.active
    property string format: "HH:mm ddd dd MMM"

    id: root
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    Row {
        StyledText {
            text: Sound.outputVolume
        }
    }
}
