import QtQuick

QtObject {
    // ===== Colors =====
    property string backgroundColor
    property string backgroundColor2
    property string interactiveColor
    property string textColor

    // ===== Sizes =====
    property int itemSize: 16

    property int borderRadius: 15
    property int margin: 7

    function opacity(color: string, opacity: real): color {
        const baseColor = Qt.color(color)
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, opacity)
    }
}