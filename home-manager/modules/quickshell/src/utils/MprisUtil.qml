pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    property list<var> players: Mpris.players.values
    property MprisPlayer activePlayer: players.length >= 1 ? players[0] : null

    function getTitle(ifNull: string): string {
        if (!activePlayer) return ifNull;
        const title = activePlayer.metadata["xesam:title"];
        return title ? title.substring(0, titleLength + 1) || ifNull : ifNull;
    }

    function getArtist(ifNull: string): string {
        if (!activePlayer) return ifNull;
        const artist = activePlayer.metadata["xesam:artist"];
        return artist ? artist.toString().substring(0, artistLength + 1) || ifNull : ifNull;
    }
}