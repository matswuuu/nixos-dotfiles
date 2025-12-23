import QtQml.Models
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
        margin: theme.margin + 4

        ColumnLayout {
            spacing: 8

            Repeater {
                model: HyprlandXkb.layouts
                delegate: StyledText {
                    text: `${modelData} - ${HyprlandXkb.fullTranslations[modelData]}`
                    color: modelData === HyprlandXkb.activeLayout ? theme.textColor2 : theme.textColor
                }
            }
        }
    }

    onClicked: {
        HyprlandXkb.changeLanguage();
    }

    RowLayout {
        StyledText {
            text: HyprlandXkb.translatedLayout
        }
    }
}