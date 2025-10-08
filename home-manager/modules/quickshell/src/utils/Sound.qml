pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Singleton {
    property string outputMutedSymbol: "dis"
    property var outputSymbols: ({
        0: "-",
        25: "low",
        50: "med",
        75: "high"
    })
    property string inputMutedSymbol: "dis"
    property var inputSymbols: ({
        0: "-",
        25: "low",
        50: "med",
        75: "high"
    })

    property bool outputMuted: false
    property int outputVolume: 0
    property bool inputMuted: false
    property int inputVolume: 0

    function getOutputSymbol() {
        if (outputMuted) return outputMutedSymbol;
        return Collection.floorValue(outputSymbols, outputVolume);
    }

    function getInputSymbol() {
        if (inputMuted) return inputMutedSymbol;
        return Collection.floorValue(inputSymbols, inputVolume);
    }

    Process {
        id: outputProcess
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                const volMatch = data.match(/([0-9.]+)/)
                outputVolume = volMatch ? parseFloat(volMatch[0]) * 100.0 : 0
                outputMuted = data.includes("[MUTED]")
            }
        }
    }

    Process {
        id: inputProcess
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                const volMatch = data.match(/([0-9.]+)/)
                inputVolume = volMatch ? parseFloat(volMatch[0]) * 100.0 : 0
                inputMuted = data.includes("[MUTED]")
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            outputProcess.running = true;
            inputProcess.running = true
        }
    }
}
