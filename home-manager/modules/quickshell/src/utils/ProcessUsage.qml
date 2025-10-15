pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property var processes: []

    Process {
        id: cpuUsageProcess
        command: ["bash", "-c", "ps -eo pid,comm,pcpu --sort=-pcpu | head -n 10 | tail -n +2"]
        stdout: StdioCollector {
            onStreamFinished: {
                processes = [];
                for (const data of text.split("\n")) {
                    const lines = data.trim().split(/\s+/).filter(Boolean);
                    if (lines.length === 0) continue;

                    const pid = lines[0];
                    const name = lines[1];
                    const percent = lines[2];

                    // Skip current process because it is always on the top
                    if (name === "ps") continue;

                    processes.push({
                        "pid": pid,
                        "name": name,
                        "percent": percent
                    });
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuUsageProcess.running = true;
        }
    }
}