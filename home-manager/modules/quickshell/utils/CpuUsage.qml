pragma Singleton

import Quickshell

Singleton {
    property double cpuUsage


    Timer {
        interval: 1
        running: true
        repeat: true
    }
}