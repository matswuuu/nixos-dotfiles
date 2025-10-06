pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property int gpuUsage: 0
    property int gpuTemp: 0
    property color tempColor

    property int maxTemp: 100

    Process {
        id: gpuUsageProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                gpuUsage = parseInt(this.text)
            }
        }
    }

    Process {
        id: gpuTempProcess
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                gpuTemp = parseInt(this.text)
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
            gpuUsageProcess.running = true
            gpuTempProcess.running = true
        }
    }
}