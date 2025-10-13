import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import Quickshell
import "./../../utils/"

Item {
    id: root
    width: 300 + 60 + 100
    height: 100 + 40

    property int maxX: 60
    property int maxY: 100
    property int valueStepX: 10
    property int valueStepY: 20

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
            // const leftMargin = 30
            // const bottomMargin = 20

            // const ctx = getContext("2d")
            // ctx.clearRect(0, 0, root.width, root.height)

            // const usage = CpuUsage.usageHistory
            // const stepX = (width - leftMargin - 10) / maxX
            // const stepY = (height - bottomMargin - 10) / maxY
            // const scaleY = height / 100

            // // --- Draw axes ---
            // ctx.strokeStyle = axisColor
            // ctx.lineWidth = 2
            // ctx.beginPath()
            // // Oy (value)
            // ctx.moveTo(leftMargin, 0)
            // ctx.lineTo(leftMargin, height - bottomMargin)
            // // Ox (time)
            // ctx.moveTo(leftMargin, height - bottomMargin)
            // ctx.lineTo(width + leftMargin, height - bottomMargin)
            // ctx.stroke()

            // ctx.fillStyle = "white"
            // for (let i = 0; i <= maxX; i += valueStepX) {
            //     const x = leftMargin + i * stepX
            //     ctx.fillText(`${i}s`, x - 8, height - 6)
            // }

            // ctx.fillStyle = "red"
            // ctx.font = "10px Sans"
            // for (let i = 0; i <= maxY; i += valueStepY) {
            //     const y = height - bottomMargin + i * stepY
            //     ctx.fillText(i.toString(), 4, y + 3)
            // }

            // // --- Draw CPU usage ---
            // ctx.beginPath()
            // ctx.strokeStyle = usageColor
            // ctx.lineWidth = 2
            // for (let i = 0; i < usage.length; i++) {
            //     const x = leftMargin + (i * stepX)
            //     const y = height - bottomMargin - (usage[i] * scaleY)
            //     if (i === 0) ctx.moveTo(x, y)
            //     else ctx.lineTo(x, y)
            // }
            // ctx.stroke()
        }
    }


    ChartView {
    //     title: "Line"
    //     anchors.fill: parent
    //     antialiasing: true

    //     LineSeries {
    //         name: "LineSeries"
    //         XYPoint { x: 0; y: 0 }
    //         XYPoint { x: 1.1; y: 2.1 }
    //         XYPoint { x: 1.9; y: 3.3 }
    //         XYPoint { x: 2.1; y: 2.1 }
    //         XYPoint { x: 2.9; y: 4.9 }
    //         XYPoint { x: 3.4; y: 3.0 }
    //         XYPoint { x: 4.1; y: 3.3 }
    //     }
    }

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 6
        color: "white"
        text: `CPU: ${CpuUsage.cpuUsage}%  Temp: ${CpuUsage.cpuTemp}°C`
        font.pixelSize: 12
    }
}
