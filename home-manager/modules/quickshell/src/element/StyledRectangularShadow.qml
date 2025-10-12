import QtQuick.Effects
import Quickshell

RectangularShadow {
    required property var target 

    anchors.fill: target
    offset.x: 6
    offset.y: 6
    radius: target.radius
    blur: 20
    spread: 1
    color: Qt.darker(target.color, 1.7)
    cached: true
}