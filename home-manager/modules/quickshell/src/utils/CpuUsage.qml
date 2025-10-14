pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property int maxHistory: 60

    property color tempColor
    property int thermalZone
    // Usage
    property int maxUsage: 100
    property int cpuUsage: 0
    // Frequency
    property int minFreq: 1
    property int maxFreq: 1
    property int cpuFreq: 1
    // Temperature
    property int maxTemp: 100
    property int cpuTemp: 1

    property list<int> usageHistory: []
    property list<int> tempHistory: []
    property list<int> freqHistory: []
    property int prevIdle: 0
    property int prevTotal: 0

    function pushToHistory(array, value) {
        if (array.length >= maxHistory)
            array.shift()
        array.push(value)
    }

    function updateUsage() {
        fileStat.reload()
        const lines = fileStat.text().split("\n")
        const cpuLine = lines[0] || ""
        const parts = cpuLine.trim().split(/\s+/)
        if (parts[0] !== "cpu") return

        const values = parts.slice(1).map(Number)
        const idle = values[3] + (values[4] || 0)
        const total = values.reduce((a, b) => a + b, 0)

        const deltaIdle = idle - prevIdle
        const deltaTotal = total - prevTotal

        if (deltaTotal > 0) {
            cpuUsage = ((deltaTotal - deltaIdle) / deltaTotal) * 100
        }

        prevIdle = idle
        prevTotal = total

        pushToHistory(usageHistory, cpuUsage)
    }

    function updateTemp() {
        fileTemp.reload()

        const tempRaw = Number(fileTemp.text()) || 0
        cpuTemp = Math.floor(tempRaw / 1000)
        const percent = cpuTemp / maxTemp
        tempColor = Qt.rgba(
            (128 + 127 * percent) / 255,
            (128 + 127 * (1 - percent)) / 255,
            0,
            1
        )

        pushToHistory(tempHistory, cpuTemp)
    }

    function getFreq(file: FileView): int {
        file.reload();
        const freqRaw = Number(file.text()) || 0;
        return Math.floor(freqRaw / 1000);
    }

    function updateFreq() {
        minFreq = getFreq(fileMinFreq);
        maxFreq = getFreq(fileMaxFreq);
        cpuFreq = getFreq(fileCurFreq);
        pushToHistory(freqHistory, cpuFreq);
    }

    Process {
        id: findZoneProcess
        command: ["bash", "-c", "for z in /sys/class/thermal/thermal_zone*; do echo $(basename $z):$(cat $z/type); done"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const types = ["cpu", "pkg", "core"]
                const lines = this.text.trim().split("\n")
                for (let line of lines) {
                    let parts = line.split(":")
                    if (parts.length < 2) continue
                    const zoneName = parts[0]
                    const type = parts[1].toLowerCase()
                    const match = types.some(k => type.includes(k))

                    if (match) {
                        thermalZone = parseInt(zoneName.replace("thermal_zone", ""))
                        timer.running = true
                        return
                    }
                }
            }
        }
    }

    FileView {
        id: fileStat
        path: "/proc/stat"
    }

    FileView {
        id: fileTemp
        path: "/sys/class/thermal/thermal_zone" + thermalZone + "/temp"
    }

    // Frequency
    FileView { 
        id: fileMinFreq;
        path: "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" 
    }
    FileView { 
        id: fileMaxFreq;
        path: "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" 
    }
    FileView { 
        id: fileCurFreq;
        path: "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq" 
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            updateUsage();
            updateTemp();
            updateFreq();
        }
    }
}