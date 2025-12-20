import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Widgets
import "./../../element/"
import "./../../utils/"

ResourceWidget {
    visible: GpuUsage.isPresented
    title: "GPU"   
    usageText: GpuUsage.gpuUsage + usageSymbol
    tempText: GpuUsage.gpuTemp + tempSymbol
    tempColor: GpuUsage.tempColor
    diagrams: [
        {
            "title": "GPU Usage (%)",
            "stepX": 10,
            "maxX": CpuUsage.maxHistory,
            "maxY": CpuUsage.maxUsage,
            "history": CpuUsage.usageHistory
        },
        {
            "title": "GPU Temperature (°C)",
            "stepX": 10,
            "maxX": CpuUsage.maxHistory,
            "maxY": CpuUsage.maxTemp,
            "history": CpuUsage.usageHistory
        },
        {
            "title": "GPU Frequency (MHz)",
            "stepX": 10,
            "minY": CpuUsage.minFreq,
            "maxX": CpuUsage.maxHistory,
            "maxY": CpuUsage.maxFreq,
            "history": CpuUsage.freqHistory
        }
    ]
}