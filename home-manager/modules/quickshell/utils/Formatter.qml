pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    function formatKBtoGB(kb: int): string {
        return kb / 1024 / 1024;
    }
}