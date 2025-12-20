import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
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

    function getUsagePoints(stepX: int, maxX: int, history) {
        const points = []
        for (let i = 0; i <= maxX; i++) {
            const x = i
            const y = i >= history.length ? -1 : history[i]
            points.push({ x: x, y: y })
        }

        return points
    }

    function updateDiagrams(diagrams) {
        for (let i = 0; i < diagrams.length; i++) {
            let item = chartRepeater.itemAt(i)
            if (item) {
                const diagram = diagrams[i]
                item.points = getUsagePoints(diagram.stepX, diagram.maxX, diagram.history)
                item.minY = diagram.minY ? diagram.minY : 0
                item.maxX = diagram.maxX
                item.maxY = diagram.maxY
                item.title = diagram.title
            }
        }
    }

    RowLayout {
        spacing: 8

        CpuWidget {

        }

        GpuWidget {

        }

        MemoryWidget {
            
        }
    }
}