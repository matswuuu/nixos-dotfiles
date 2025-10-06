import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property real margin: 5

    implicitWidth: 100
    implicitHeight: 100

    // implicitWidth: child.implicitWidth + margin * 2
    // implicitHeight: child.implicitHeight + margin * 2

    RowLayout {
        id: layout
        spacing: 8

        Text {
            id: title
            text: "123"
        }

        Text {
            id: percentUsage
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        // onEntered: interactiveTooltip.open()
        // onExited: interactiveTooltip.close()

        onEntered: interactiveTooltip.visible = true
        onExited: interactiveTooltip.visible = false
        onClicked: {
            print("Rectangle clicked!")
        }
    }

    // Popup {
    //     id: interactiveTooltip
    //     // x: 0
    //     // y: parent.height + 5
    //     // parent: root

    //     // Optional: set some styling
    //     // background: Rectangle {
    //     //     color: "lightgrey"
    //     //     border.color: "black"
    //     //     radius: 4
    //     // }
    //     contentItem: Item {
    //         RowLayout {
    //             spacing: 4
    //         Button {
    //             text: "Click me"
    //             onClicked: {
    //                 console.log("Button inside tooltip clicked!")
    //                 // Do something
    //                 interactiveTooltip.close()
    //             }
    //         }
    //         }
    //     }

    //     MouseArea {
    //         anchors.fill: parent
    //         hoverEnabled: true
    //         onClicked: {
    //             print("test")
    //         }
    //     }
    // 

    Loader {
        id: interactiveTooltip
        sourceComponent: PopupWindow {
            implicitWidth: 500
            implicitHeight: 500
            visible: false
            anchor {
                window: root.QsWindow.window
                item: root.layout
                // edges: root.anchorEdges
                // gravity: root.anchorGravity
            }

            Rectangle {
                color: "blue"
                implicitWidth: 100
                implicitHeight: 100
            }
        }
    }
}
