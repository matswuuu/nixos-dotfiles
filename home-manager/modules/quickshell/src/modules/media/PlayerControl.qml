import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "./../../element/"
import "./../../utils/"
import "./../../theme/"

WrapperRectangle {
    readonly property var theme: Themes.active

    color: theme.backgroundColor2
    radius: theme.borderRadius
    margin: theme.margin + 4

    RowLayout {
        spacing: 14

        Rectangle { // TODO: Replace later with track image
            color: "green"
            implicitWidth: 150
            implicitHeight: 150
        }

        Rectangle {
            color: "blue"
            implicitWidth: 300
            implicitHeight: 150

            ColumnLayout {
                spacing: 4

                StyledText {
                    text: MprisUtil.getTitle("Untitled")
                    font {
                        pixelSize: 18
                    }
                }
                StyledText {
                    text: MprisUtil.getArtist("Unknown")
                }
            }

            ColumnLayout {
                spacing: 4
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 10
                }

                StyledText {
                    text: "1:54/2:34"
                }

                StyledText {
                    text: Icons.skip_next
                }

                ProgressBar {
                    id: progressBar
                    value: 0.5
                    implicitWidth: 300
                    implicitHeight: 4

                    Material.theme: Material.Dark
                    Material.accent: Material.Red


                    // background: Rectangle {
                    //     width: parent.implicitWidth
                    //     color: theme.backgroundColor2
                    //     radius: theme.borderRadius
                    // }

                    // contentItem: Rectangle {
                    //     width: progressBar.implicitWidth * parent.value
                    //     height: progressBar.implicitHeight
                    //     color: theme.interactiveColor
                    //     radius: theme.borderRadius
                    // }

                    // Behavior on value {
                    //     NumberAnimation {
                    //         duration: 120
                    //         easing.type: Easing.InOutQuad
                    //     }
                    // }
                }
            }
        }
    }
}
