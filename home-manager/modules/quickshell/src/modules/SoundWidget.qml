import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./../utils/"
import "./media/"

WrapperRectangle {
    readonly property var theme: Themes.active
    property string format: "HH:mm ddd dd MMM"

    color: theme.backgroundColor
    radius: theme.borderRadius
    margin: theme.margin

    RowLayout {
        spacing: 8

        StyledPopup {
            visible: MprisUtil.activePlayer != null
            contentItem: PlayerControl {
        
            }

            MprisWidget {
            }
        }

        StyledPopup {
            contentItem: Rectangle {
                implicitWidth: 100
                implicitHeight: 100
                color: "red"
            }
        }

        RowLayout {
            spacing: 4
            
            MaterialSymbol {
                text: Sound.getOutputSymbol()
                font.pixelSize: 18
            }
            MaterialSymbol {
                text: Sound.getInputSymbol()
                font.pixelSize: 18
            }
        }
    }
}
