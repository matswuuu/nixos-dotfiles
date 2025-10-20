pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var symbols: ({
        0: "wb_sunny"
    })

    property int maxBrightness
    property int currentBrightness

    signal brightnessChanged(currentBrightness: int, maxBrightness: int)

    function getSymbol(): string {
        return Collection.floorValue(symbols, currentBrightness);
    }

    Process {
        id: maxBrightnessProc
        command: ["brightnessctl", "m"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                maxBrightness = parseInt(data)
            }
        }
    }
    Process {
        id: currentBrightnessProc
        command: ["brightnessctl", "g"]
        stdout: SplitParser {
            onRead: data => {
                const currentBrightness = parseInt(data);
                if (currentBrightness != root.currentBrightness) {
                    root.currentBrightness = currentBrightness
                    brightnessChanged(currentBrightness, maxBrightness);
                }
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            currentBrightnessProc.running = true;
        }
    }
}