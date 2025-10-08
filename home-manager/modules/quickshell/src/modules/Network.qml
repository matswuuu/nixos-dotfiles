pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "."

Singleton {
    property string offSymbol: "󰖪"
    property string lanSymbol: ""
    property var wifiSymbols: ({
        0: "󰤯",
        25: "󰤟",
        50: "󰤢",
        75: "󰤥",
        100: "󰤨"
    })

    property int networkStrength
    property int type: NetworkType.NONE
    property string connectionSymbol: getFormattedConnection()

    function getFormattedConnection(): string {
        switch (type) {
            case 0:
                return offSymbol
            case 1:
                return lanSymbol
            case 2:
                const keys = Object.keys(wifiSymbols).map(Number).sort((a, b) => a - b)
                let floorKey = 0
                for (let i = 0; i < keys.length; i++) {
                    if (networkStrength >= keys[i]) floorKey = keys[i]
                    else break
                }
                return wifiSymbols[floorKey]
        }
    }

    Process {
        id: typeProcess
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | awk -F: '$2 == \"connected\" {print $1}'"]
        stdout: SplitParser {
            onRead: data => {
                switch (data.trim()) {
                    case "wifi":
                        type = NetworkType.WIFI
                        break
                    case "ethernet":
                        type = NetworkType.ETHERNET
                        break
                    default:
                        type = NetworkType.NONE
                }
            }
        }
    }

    Process {
        id: strengthProcess
        running: true
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                networkStrength = parseInt(data);
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            typeProcess.running = true
            strengthProcess.running = true
        }
    }
}
