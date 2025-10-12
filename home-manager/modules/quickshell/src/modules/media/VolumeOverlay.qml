import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "./../../utils/"
import "./../../theme/"
import "./../../element/"

PopupWindow {
    id: root
    visible: false
    color: "transparent"
    implicitWidth: wrapper.width
    implicitHeight: wrapper.height

    onVisibleChanged: if (visible && anchor.item) {
        anchor.rect.x = (anchor.item.width - width) / 2
        anchor.rect.y = anchor.item.height + 10
    }

    readonly property var theme: Themes.active
    property int volume
    property bool muted

    Item {
        id: wrapper
        anchors.centerIn: parent
        width: rectangle.width + 20
        height: rectangle.height + 20

        StyledRectangularShadow {
            target: rectangle
        }

        WrapperRectangle {
            id: rectangle
            color: theme.backgroundColor
            radius: theme.borderRadius
            margin: theme.margin + 4

            RowLayout {
                spacing: 8

                StyledProgressBar {
                    value: volume / 100
                    implicitWidth: 180
                }

                // ProgressBar {
                //     id: progressBar
                //     value: volume / 100
                //     implicitWidth: 180
                //     implicitHeight: 4

                //     background: Rectangle {
                //         width: parent.implicitWidth
                //         color: theme.backgroundColor2
                //         radius: theme.borderRadius
                //     }

                //     contentItem: Rectangle {
                //         width: progressBar.implicitWidth * parent.value
                //         height: progressBar.implicitHeight
                //         color: theme.interactiveColor
                //         radius: theme.borderRadius
                //     }

                //     Behavior on value {
                //         NumberAnimation {
                //             duration: 120
                //             easing.type: Easing.InOutQuad
                //         }
                //     }
                // }

                StyledText {
                    text: `${volume}%`
                }
            }

            SequentialAnimation on opacity {
                id: fadeAnim
                PropertyAction { value: 1 }
                PauseAnimation { duration: 1000 }
                PropertyAnimation { to: 0; duration: 200 }
                onFinished: {
                    root.visible = false
                }
            }
        }

    }

    Connections {
        target: Sound

        function onOutputUpdated(volume: int, muted: bool) {
            root.volume = volume
            root.muted = muted

            fadeAnim.stop()
            root.visible = true
            fadeAnim.start()
        }
    }
}
