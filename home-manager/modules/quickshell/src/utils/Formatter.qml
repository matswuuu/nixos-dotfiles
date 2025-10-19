pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    function formatKBtoGB(kb: int): string {
        return (kb / 1024 / 1024).toFixed(1);
    }

    function formatTime(seconds) {
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        const ss = secs < 10 ? "0" + secs : secs;
        return mins + ":" + ss;
    }
}