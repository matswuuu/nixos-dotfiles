import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "./../element/"
import "./../utils/"
import "./../theme/"
import "./media/"

RowLayout {
    readonly property Theme theme: Themes.active

    property int titleLength: 32
    property int artistLength: 16

    property string title: MprisUtil.getTitle("")
    property string artist: MprisUtil.getArtist("")

    visible: MprisUtil.activePlayer != null

    RowLayout {
        spacing: 4

        StyledText {
            text: title
        }
        StyledText {
            text: "-"
            visible: title != "" && artist != ""
        }
        StyledText {
            text: artist
        }
    }
}
