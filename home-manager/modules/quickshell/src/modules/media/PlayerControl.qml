import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "./../../element/"
import "./../../utils/"
import "./../../theme/"

WrapperRectangle {
    readonly property var theme: Themes.active

    id: player
    child: l
    // color: theme.opacity(theme.backgroundColor2, 0.1)
    color: "transparent"
    radius: theme.borderRadius
    margin: theme.margin + 4

    //   layer.enabled: true
            // layer.smooth: true

    // MultiEffect {
    //     anchors.fill: player
    //     source: player
    //     blurEnabled: true
    //     blur: 0.2       // 0.0–1.0 range (approximate)
    //     blurMax: 64.0   // blur radius in pixels
    //     // brightness: 1.0
    //     // contrast: 1.0
    //     // saturation: 1.0
    // }


    RowLayout {
        id: l
        spacing: 14

        StyledImage {
            width: 150
            height: 150
            source: MprisUtil.getImage()
            radius: theme.borderRadius
        }

        Item {
            id: rightBlock
            implicitWidth: 300
            implicitHeight: 150

            ColumnLayout {
                spacing: 4

                StyledText {
                    text: MprisUtil.getTitle(64, "Untitled")
                    font {
                        pixelSize: 18
                    }
                    width: rightBlock.width
                    Layout.fillWidth: true
                }
                StyledText {
                    text: MprisUtil.getArtist(64, "Unknown")
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
                    text: Formatter.formatTime(MprisUtil.getPlayedSeconds()) + "/" + Formatter.formatTime(MprisUtil.getTotalSeconds())
                }

                RowLayout {
                    id: layout
                    spacing: 4

                    MaterialSymbol {
                        id: skipPrevous
                        text: "skip_previous"
                    }

                    StyledProgressBar {
                        id: progressBar
                        value: MprisUtil.getPlayedSeconds() / MprisUtil.getTotalSeconds()
                        implicitWidth: rightBlock.width - (skipPrevous.width + skipNext.width + layout.spacing * 2)
                    }

                    MaterialSymbol {
                        id: skipNext
                        text: "skip_next"
                    } 
                }
            }
        }
    }
}
