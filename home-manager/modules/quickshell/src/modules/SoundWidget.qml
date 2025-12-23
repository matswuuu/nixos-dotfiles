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
                width: 200
                height: 200

                VolumeIndicator {
                    visible: true
                    playAnimation: false
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
}
