import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../../element"
import "./../../theme"

WrapperRectangle {
    readonly property var theme: Themes.active
    property string title
    property real value
    property string icon

    id: root
    color: theme.backgroundColor2
    radius: theme.borderRadius
    margin: theme.margin + 4
    visible: false

    // StyledRectangularShadow {
    //     target: layout
    // }

    function show() {
        fadeAnim.stop()
        root.visible = true
        fadeAnim.start()
    }

    RowLayout {
        id: layout
        spacing: 10
        anchors {
            margins: 20
        }

        MaterialSymbol {
            text: icon
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 4

            Item {
                id: textBlock
                implicitWidth: progressBar.width
                implicitHeight: Math.max(titleText.height, valueText.height)

                StyledText {
                    id: titleText
                    text: title
                }

                StyledText {
                    id: valueText
                    anchors {
                        top: textBlock.top
                        right: textBlock.right
                    }
                    text: value
                }
            }

            StyledProgressBar {
                id: progressBar
                implicitWidth: 180
                value: root.value / 100
            }
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