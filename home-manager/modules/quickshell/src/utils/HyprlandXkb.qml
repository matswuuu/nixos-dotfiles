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
    property var fullTranslations: {
        "us": "English",
        "ru": "Russian"
    }

    // Json object with keyboard properties 
    property var keyboard 
    property string activeLayout: ""
    property var layouts: []
    property string translatedLayout: activeLayout in translations ? translations[activeLayout] : activeLayout

    function changeLanguage() {
        changeLanguage.running = true;
    }

    Process {
        id: fetchLayoutsProc
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parsedOutput = JSON.parse(this.text);
                keyboard = parsedOutput["keyboards"].find(kb => kb.main === true);
                layouts = keyboard["layout"].split(",");
                activeLayout = layouts[keyboard.active_layout_index];
            }
        }
    }

    Process {
        id: changeLanguage
        command: [
            "hyprctl", 
            "switchxkblayout", 
            keyboard ? keyboard["name"] : "", 
            "next"
        ]
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