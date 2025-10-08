pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    property var translations: {
        "us": "eng",
        "ru": "ru"
    }
    property string activeLayout
    property string translatedLayout: activeLayout in translations ? translations[activeLayout] : activeLayout
 
    Process {
        id: fetchLayoutsProc
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parsedOutput = JSON.parse(this.text);
                const keyboard = parsedOutput["keyboards"].find(kb => kb.main === true);
                const layouts = keyboard["layout"].split(",");
                activeLayout = layouts[keyboard.active_layout_index]
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                fetchLayoutsProc.running = true;
            }
        }
    }
}