pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property int maxHistory: 60

    property int maxUsage: 100
    property int gpuUsage: 0

    property int maxTemp: 100
    property int gpuTemp: 0
    property color tempColor

    // Probably we need to add AMD, but I don't have one to test
    property bool isPresented: nvidia
    property bool nvidia

    property list<int> usageHistory: []
    property list<int> tempHistory: []

    function pushToHistory(array, value) {
        if (array.length >= maxHistory)
            array.shift()
        array.push(value)
    }

    Process {
        id: checkProcess
        command: ["which", "nvidia-smi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                nvidia = this.text.trim().length > 0
            }
        }
    }

    Process {
        id: gpuUsageProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                gpuUsage = parseInt(this.text)
                pushToHistory(usageHistory, gpuUsage)
            }
        }
    }

    Process {
        id: gpuTempProcess
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                gpuTemp = parseInt(this.text)
                pushToHistory(tempHistory, gpuTemp)

                const percent = gpuTemp / maxTemp
                tempColor = Qt.rgba(
                    (128 + 127 * percent) / 255,
                    (128 + 127 * (1 - percent)) / 255,
                    0,
                    1
                )
            }
        } 
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (nvidia) {
                gpuUsageProcess.running = true
                gpuTempProcess.running = true
            }
        }
    }
}