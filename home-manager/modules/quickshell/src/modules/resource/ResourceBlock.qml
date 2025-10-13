import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
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

        StyledPopup {
            contentItem: WrapperRectangle {
                color: theme.backgroundColor2
                radius: theme.borderRadius
                margin: theme.margin + 4

                RowLayout {
                    StyledText {
                        text: "CPU"
                    }

                    UsageDiagram {
                        maxX: CpuUsage.maxHistory
                        maxY: CpuUsage.maxFreq
                        valueStepX: 10
                        valueStepY: CpuUsage.maxFreq / 5
                    }

                    UsageDiagram {
                        maxX: CpuUsage.maxHistory
                        maxY: CpuUsage.maxTemp
                        valueStepX: 10
                        valueStepY: CpuUsage.maxTemp / 5
                    }
                }
            }

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
        }

        StyledPopup {
            visible: GpuUsage.isPresented
            contentItem: WrapperRectangle {
                color: theme.backgroundColor2
                radius: theme.borderRadius
                margin: theme.margin + 4

                StyledText {
                    text: "GPU"
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
        }

        StyledPopup {
            contentItem: WrapperRectangle {
                color: theme.backgroundColor2
                radius: theme.borderRadius
                margin: theme.margin + 4

                StyledText {
                    text: "MEMORY"
                }
            }

            StyledText {
                text: Formatter.formatKBtoGB(MemoryUsage.memoryUsed) + "G"
            }
        }
    }
}