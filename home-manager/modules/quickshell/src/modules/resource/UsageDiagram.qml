import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "./../../element/"

Item {
    property var points: []

    property int paddingLeft
    property int paddingRight
    property int paddingTop
    property int paddingBottom
    
    property int minX
    property int minY
    property int maxX
    property int maxY
    property int xSteps
    property int ySteps
    property bool drawPoints

    property string title
    property int fontSize: 14

    property string pointColor: "white"
    property string lineColor: "white"
    property string valueColor: "red"
    property string axisColor: "white"
    property string textColor: "white"

    property var xFormatter: (x) => x
    property var yFormatter: (y) => y

    id: root

    onPointsChanged: {
        canvas.requestPaint()
    }

    Item {
        id: header
        width: root.width
        height: root.height

        StyledText {
            text: title
            z: 1
            anchors {
                right: parent.right
                top: parent.top
            }
        }

        Canvas {
            id: canvas
            width: root.width
            height: root.height

            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Cooperative

            function getScaleX() { 
                return (width - root.paddingLeft - root.paddingRight) / (root.maxX || 1) 
            }
            
            function getScaleY() { 
                return (height - root.paddingTop - root.paddingBottom) / (root.maxY || 1) 
            }

            function mapX(x) {
                return root.paddingLeft + x * getScaleX() 
            }

            function mapY(y) {
                return height - root.paddingBottom - y * getScaleY() 
            }

            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height) 

                const w = width
                const h = height
                
                // Map properties to local constants for readability
                const pL = root.paddingLeft
                const pR = root.paddingRight
                const pT = root.paddingTop
                const pB = root.paddingBottom
                
                const fontPx = root.fontSize

                ctx.font = `${fontPx}px JetBrains Mono`

                const tickSize = Math.max(4, fontPx * 0.4)

                // Calculate scales using the specific side paddings
                const scaleX = (w - pL - pR) / (maxX - minX || 1)
                const scaleY = (h - pT - pB) / (maxY - minY || 1)

                // line
                if (points.length > 0) {
                    ctx.strokeStyle = lineColor
                    ctx.lineWidth = 2
                    ctx.beginPath()

                    ctx.moveTo(mapX(points[0].x), mapY(points[0].y))
                    for (let i = 1; i < points.length; i++) {
                        const pt = points[i]
                        if (pt.x < 0 || pt.y < 0) continue
                        ctx.lineTo(mapX(pt.x), mapY(pt.y))
                    }
                    ctx.stroke()
                }

                // points
                if (drawPoints) {
                    ctx.fillStyle = pointColor
                    for (const pt of points) {
                        if (pt.x < 0 || pt.y < 0) continue
                        ctx.beginPath()
                        ctx.arc(mapX(pt.x), mapY(pt.y), fontPx * 0.2, 0, Math.PI * 2)
                        ctx.fill()
                    }
                }

                // axes
                ctx.strokeStyle = axisColor
                ctx.lineWidth = 1

                ctx.beginPath()
                ctx.moveTo(pL, pT)
                ctx.lineTo(pL, h - pB)
                ctx.lineTo(w - pR, h - pB)
                ctx.stroke()

                // labels
                ctx.strokeStyle = valueColor
                ctx.fillStyle = textColor
                ctx.lineWidth = 2

                // X axis labels (OX)
                ctx.textAlign = "center"
                ctx.textBaseline = "top"

                for (let i = 0; i <= xSteps; i++) {
                    const value = minX + (maxX - minX) * (i / xSteps)
                    const x = mapX(value)

                    ctx.fillText(
                        xFormatter(value.toFixed(0)),
                        x,
                        h - pB + tickSize + 2
                    )

                    ctx.beginPath()
                    ctx.moveTo(x, h - pB)
                    ctx.lineTo(x, h - pB + tickSize)
                    ctx.stroke()
                }

                // Y axis labels (OY)
                ctx.textAlign = "right"
                ctx.textBaseline = "middle"

                for (let i = 0; i <= ySteps; i++) {
                    const value = minY + (maxY - minY) * (i / ySteps)
                    const y = mapY(maxY * (i / ySteps))

                    ctx.fillText(
                        yFormatter(value.toFixed(0)),
                        pL - tickSize - 2,
                        y
                    )

                    ctx.beginPath()
                    ctx.moveTo(pL - tickSize, y)
                    ctx.lineTo(pL, y)
                    ctx.stroke()
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: (mouse) => {
                    let closestPoint = null
                    let minDist = 20

                    for (const pt of root.points) {
                        const px = canvas.mapX(pt.x)
                        const py = canvas.mapY(pt.y)
                        const dist = Math.pow(mouse.x - px, 2) + Math.pow(mouse.y - py, 2)
                        
                        if (dist < minDist) {
                            minDist = dist
                            closestPoint = pt
                        }
                    }

                    if (closestPoint && closestPoint.x != -1 && closestPoint.y != -1) {
                        chartToolTip.text = `X: ${xFormatter(closestPoint.x)}\nY: ${yFormatter(closestPoint.y)}`
                        chartToolTip.x = mouse.x + 10
                        chartToolTip.y = mouse.y - 40
                        chartToolTip.visible = true
                    } else {
                        chartToolTip.visible = false
                    }
                }
                onExited: chartToolTip.visible = false
            }

            ToolTip {
                id: chartToolTip
                delay: 0
                timeout: -1
                background: Rectangle {
                    color: "#222"
                    border.color: "#4aa3ff"
                    radius: 4
                }
                contentItem: StyledText {
                    text: chartToolTip.text
                    color: textColor
                    font.pixelSize: 12
                }
            }
        }
    }
}
