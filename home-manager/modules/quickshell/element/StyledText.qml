import QtQuick
import Quickshell
import ".././theme/"

Text {
    readonly property var theme: Themes.active

    font {
        family: "JetBrainsMono Nerd Font"
        weight: Font.Bold
        pixelSize: 13
    }
    color: theme.textColor
}