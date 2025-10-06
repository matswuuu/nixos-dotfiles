import  ".././theme/"
import QtQml.Models
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

WrapperRectangle {
    readonly property var theme: Themes.active

    property list<string> appOrder: [
        "chrome_status_icon_1", // Discord
        "telegram"
    ]

    property list<SystemTrayItem> items: {
        var items = [...SystemTray.items.values];
        return items.sort((a, b) => {
            const aname = a.id.toLowerCase();
            const bname = b.id.toLowerCase();
            const ai = appOrder.findIndex(k => aname.includes(k)); 
            const bi = appOrder.findIndex(k => bname.includes(k));

            if (ai !== -1 && bi !== -1) return ai - bi;
            if (ai !== -1) return -1;
            if (bi !== -1) return 1;

            return aname.localeCompare(bname);
        });
    }

    id: root
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        spacing: 4

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