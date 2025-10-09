import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "./../element/"
import "./../theme/"

RowLayout {
    readonly property Theme theme: Themes.active

    property int titleLength: 32

    property list<var> players: Mpris.players.values
    property MprisPlayer activePlayer: players.length >= ? players[0] : null
    property string title: getTitle()
    property string artist: getArtist()

    visible: activePlayer != null

    function getTitle(): string {
        if (!activePlayer) return "";
        const title = activePlayer.metadata["xesam:title"];
        return title ? title.substring(0, titleLength + 1) || "" : "";
    }

    function getArtist(): string {
        if (!activePlayer) return ""
        return activePlayer.metadata["xesam:artist"]?.[0] || "";
    }

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
