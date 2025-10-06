pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick

Singleton {
    property int cpuUsage: 0
    property int cpuTemp: 0
    property color tempColor

    property int thermalZone: getCpuThermalZone()
    property int maxTemp: 100
    property int prevIdle: 0
    property int prevTotal: 0

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
    }

    function getCpuThermalZone() {
        const dir = "/sys/class/thermal/"

        const fs = File.list(dir)
        for (let i = 0; i < fs.length; i++) {
            if (!fs[i].startsWith("thermal_zone")) continue

            const typeFile = dir + fs[i] + "/type"
            const typeContent = Quickshell.File.read(typeFile) || ""
            if (typeContent.toLowerCase().includes("cpu")) {
                return parseInt(fs[i].replace("thermal_zone",""))
            }
        }

        return 0
    }

    FileView {
        id: thermal
        path: "/sys/class/thermal/"
    }

    FileView {
        id: fileStat
        path: "/proc/stat"
    }

    FileView {
        id: fileTemp
        path: "/sys/class/thermal/thermal_zone" + thermalZone + "/temp"
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            updateUsage()
            updateTemp()
        }
    }
}