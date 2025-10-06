import  ".././theme/"
import QtQml.Models
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    readonly property var theme: Themes.active
    property list<var> items: SystemTray.items.values

    id: root

    ClippingWrapperRectangle {
        color: theme.backgroundColor
        radius: theme.borderRadius
        margin: theme.margin

        RowLayout {
            spacing: 8

            Repeater {
                model: root.items
                delegate: TrayItem {
                    required property SystemTrayItem modelData
                    item: modelData
                    // Layout.fillHeight: !root.vertical
                    // Layout.fillWidth: root.vertical
                    // onMenuClosed: root.releaseFocus();
                    // onMenuOpened: (qsWindow) => {
                    //     root.setExtraWindowAndGrabFocus(qsWindow);
                    // }
                }
            }
        }
    }
}