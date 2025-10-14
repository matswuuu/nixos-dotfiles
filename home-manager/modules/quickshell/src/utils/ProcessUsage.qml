pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property var data: []

    Process {
        id: cpuUsageProcess
        command: ["bash", "-c", "ps -eo pid,comm,pcpu --sort=-pcpu | head -n 10 | tail -n +2"]
        stdout: SplitParser {
            onRead: data => {
                const lines = data.trim().split(/\s+/).filter(Boolean)
                const pid = lines[0]
                const name = lines[1]
                const percent = lines[2]
                data.push({
                    "pid": pid,
                    "name": name,
                    "percent": percent
                })

                // const formatted = lines.map(line => {
                //     const parts = line.trim().split(/\s+/)
                //     return `${parts[0]}:${parts[1]}%`
                // }).join("  ")
                for (const line of lines) {
                    // print(line)
                }

                print(lines)
            }
        }
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            cpuUsageProcess.running = true;
        }
    }
}