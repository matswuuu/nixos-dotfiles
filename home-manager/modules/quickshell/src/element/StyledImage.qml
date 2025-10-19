import QtQuick
import QtQuick.Effects

Item {
    property var source
    property int radius

    id: root

    Image {
        id: image
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectCrop
        source: root.source
        width: root.width
        height: root.width
        visible: false
    }

    MultiEffect {
        source: image
        anchors.fill: image
        maskEnabled: true
        maskSource: mask
    }

    Item {
        id: mask
        width: image.width
        height: image.height
        layer.enabled: true
        visible: false

        Rectangle {
            width: image.width
            height: image.height
            radius: root.radius
            color: "black"
        }
    }
}