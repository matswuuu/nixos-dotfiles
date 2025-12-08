import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import QtGraphs
import Quickshell
import "./../../utils/"
import "./../../element/"

Item {
    id: root
    width: 300 + 60 + 100
    height: 100 + 40

    property string title
    property var history
    property double maxX
    property double maxY
    property double valueStepX: 1
    property double valueStepY: 1

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: canvas.requestPaint()
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#202020"
        radius: 8
        border.color: "#404040"
    }

    Canvas {
        id: canvas
        // anchors.fill: parent
        width: 300
        height: 100
        property color usageColor: "#00FF88"
        property color axisColor: "#FF5555"

        onPaint: {
            const leftMargin = 30
            const bottomMargin = 20
            const textHeight = 10

            const ctx = getContext("2d")
            ctx.clearRect(0, 0, root.width, root.height)

            const stepX = (width - leftMargin - textHeight) / maxX
            const stepY = (height - bottomMargin - textHeight) / maxY
            const scaleY = height / 100

            // Offsets for label spacing
            const xLabelOffset = 6    // space below Ox
            const yLabelOffset = 6    // space left of Oy

            // --- Draw axes ---
            ctx.strokeStyle = axisColor
            ctx.lineWidth = 2
            ctx.beginPath()

            // Oy (vertical)
            ctx.moveTo(leftMargin, 0)
            ctx.lineTo(leftMargin, height - bottomMargin)

            // Ox (horizontal)
            ctx.moveTo(leftMargin, height - bottomMargin)
            ctx.lineTo(width - 5, height - bottomMargin)
            ctx.stroke()

            // --- Draw X axis labels ---
            ctx.fillStyle = "white"
            ctx.font = "10px Sans"
            ctx.textAlign = "center"
            ctx.textBaseline = "top"

            for (let i = 0; i <= maxX; i += valueStepX) {
                const x = leftMargin + i * stepX
                const y = height - bottomMargin + xLabelOffset
                ctx.fillText(`${i}s`, x, y)
            }

            // --- Draw Y axis labels ---
            ctx.fillStyle = "red"
            ctx.textAlign = "right"
            ctx.textBaseline = "middle"

            for (let i = 0; i <= maxY; i += valueStepY) {
                const y = height - bottomMargin - i * stepY
                ctx.fillText(i.toString(), leftMargin - yLabelOffset, y)
            }

            // --- Draw CPU usage line ---
            ctx.beginPath()
            ctx.strokeStyle = usageColor
            ctx.lineWidth = 2

            for (let i = 0; i < history.length; i++) {
                const x = leftMargin + (i * stepX)
                const y = height - bottomMargin - (history[i] * scaleY)

                if (i === 0) ctx.moveTo(x, y)
                else ctx.lineTo(x, y)
            }

            ctx.stroke()

        }
    }

    StyledText {
        text: title
    }

    StyledText {
        text: ProcessUsage.processes
    }
}
