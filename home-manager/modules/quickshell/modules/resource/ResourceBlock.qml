import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import "./../../element/"
import "./../../utils/"

WrapperRectangle {
    property string tempSymbol: "°C"
    property string usageSymbol: "%"

    id: resourcesLayout
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        spacing: 8

        RowLayout {
            spacing: 4

            StyledText {
                text: "CPU"
            }
            StyledText {
                text: CpuUsage.cpuUsage + usageSymbol
            }
            StyledText {
                text: CpuUsage.cpuTemp + tempSymbol
                color: CpuUsage.tempColor
            }
        }

        RowLayout {
            spacing: 4

            StyledText {
                text: "GPU"
            }
            StyledText {
                text: GpuUsage.gpuUsage + usageSymbol
            }
            StyledText {
                text: GpuUsage.gpuTemp + tempSymbol
                color: GpuUsage.tempColor
            }
        }

        StyledText {
            text: Formatter.formatKBtoGB(MemoryUsage.memoryUsed) + "G"
        }
    }
}