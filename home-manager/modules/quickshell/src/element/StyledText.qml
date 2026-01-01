import QtQuick
import Quickshell
import "./../theme/"

Text {
    readonly property var theme: Themes.active

    font {
        family: theme.font
        weight: Font.Bold
        pixelSize: 14
    }
    color: theme.textColor
    wrapMode: Text.WordWrap
}