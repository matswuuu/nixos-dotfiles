import QtQml.Models
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "./../element/"
import "./../theme/"
import "./../utils/"

WrapperRectangle {
    readonly property var theme: Themes.active

    id: root
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        spacing: 4

        StyledText {
            text: HyprlandXkb.translatedLayout
        }

        StyledText {
            text: Battery.percentage + "%"
            visible: Battery.present
        }

        StyledText {
            text: Network.connectionSymbol
        }

        StyledText {
            text: IpInfo.countryCode || "?"
        }

        StyledText {
            text: Bluetooth.stateSymbol
        }
    }
}