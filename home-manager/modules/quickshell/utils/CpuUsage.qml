pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property double cpuUsage: 0
    property double cpuTemp: 0

    Timer {
        interval: 1
        running: true
        repeat: true
        onTriggered: {
            
        }
    }
}