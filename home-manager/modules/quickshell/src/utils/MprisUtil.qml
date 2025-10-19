pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick

// TODO: Migrate to QtQuick.MediaPlayer
Singleton {
    property list<var> players: Mpris.players.values
    property MprisPlayer activePlayer: players.length >= 1 ? players[0] : null

    function getTitle(length: int, ifNull: string): string {
        if (!activePlayer) return ifNull;
        const title = activePlayer.trackTitle;
        return title ? title.substring(0, length + 1) || ifNull : ifNull;
    }

    function getArtist(length: int, ifNull: string): string {
        if (!activePlayer) return ifNull;
        const artist = activePlayer.trackArtist;
        return artist ? artist.toString().substring(0, length + 1) || ifNull : ifNull;
    }

    function getImage() {
        return activePlayer ? activePlayer.trackArtUrl : null;
    }

    function getPlayedSeconds() {
        if (!activePlayer) return 0;
        
        const pos = activePlayer.position;
        const total = getTotalSeconds();
        return pos > total ? pos - total : pos;
    }

    function getTotalSeconds() {
        return activePlayer ? activePlayer.length : 0;
    }

    Timer {
        running: activePlayer && activePlayer.playbackState == MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }
}