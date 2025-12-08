import QtQuick
import QtQuick.Controls
import Quickshell

Button {
    required property string symbol

    width: 16
    height: 16
    background: Rectangle {
        color: "transparent"
    }
    contentItem: MaterialSymbol {
        id: materialSymbol
        text: symbol
    }
}