pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Singleton {
    property int outputVolume: 0
    property int inputVolume: 0
    property bool outputMuted: false
    property bool inputMuted: false

    function getOutputIcon() {
        if (outputMuted) return "volume_off"
        if (outputVolume < 30) return "volume_down"
        if (outputVolume < 70) return "volume_up"
        return "volume_high"
    }

    function getInputIcon() {
        if (inputMuted) return "mic_off"
        if (inputVolume < 30) return "mic_1"
        if (inputVolume < 70) return "mic_2"
        return "mic_3"
    }

    Process {
        id: updateProcess
        // Uses wpctl to get both sink (output) and source (input) info
        command: ["sh", "-c", `
            wpctl get-volume @DEFAULT_AUDIO_SINK@
            wpctl get-volume @DEFAULT_AUDIO_SOURCE@
        `]

        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split("\\n")
                if (lines.length >= 1) {
                    // Output: "Volume: 0.45 [MUTED]" or "Volume: 0.89"
                    const sinkLine = lines[0]
                    const volMatch = sinkLine.match(/([0-9.]+)/)
                    outputVolume = volMatch ? Math.round(parseFloat(volMatch[1]) * 100) : 0
                    outputMuted = sinkLine.includes("[MUTED]")
                }
                if (lines.length >= 2) {
                    const srcLine = lines[1]
                    const volMatch = srcLine.match(/([0-9.]+)/)
                    inputVolume = volMatch ? Math.round(parseFloat(volMatch[1]) * 100) : 0
                    inputMuted = srcLine.includes("[MUTED]")
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: updateProcess.running = true
    }
}
