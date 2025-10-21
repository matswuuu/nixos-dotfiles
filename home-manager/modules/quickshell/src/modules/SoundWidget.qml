import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./../utils/"
import "./media/"

ClippingWrapperRectangle {
    readonly property var theme: Themes.active
    property string format: "HH:mm ddd dd MMM"

    id: root
    implicitWidth: 100
    implicitHeight: 30
    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        id: layout
        anchors.fill: parent

        Rectangle {
            implicitWidth: 50
            implicitHeight: 100
            color: "red"
        }
    }

    // RowLayout {
    //     spacing: 8

    //     Rectangle {
    //         implicitWidth: 50
    //         implicitHeight: 50
    //         color: "red"
    //     }

    //     StyledPopup {
    //         id: test
    //         // contentItem: PlayerControl {
    //         // }

    //         contentItem: Rectangle {
    //             width: 100
    //             height: 300
    //             anchors.topMargin: 100
    //         }

    //         MprisWidget {

    //         }
    //     }

    //     Timer {
    //         interval: 1000
    //         running: true
    //         repeat: true
    //         onTriggered: {
    //             print(test.width + " " + test.height)
    //         }
    //     }

    //     // StyledPopup {
    //     //     contentItem: PlayerControl {
    //     //     }

    //     //     RowLayout {
    //     //         spacing: 4
                
    //     //         MaterialSymbol {
    //     //             text: Sound.getOutputSymbol()
    //     //             font.pixelSize: 18
    //     //         }
    //     //         MaterialSymbol {
    //     //             text: Sound.getInputSymbol()
    //     //             font.pixelSize: 18
    //     //         }
    //     //     }
    //     // }        
    // }
}
