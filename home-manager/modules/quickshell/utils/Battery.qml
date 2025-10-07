pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    property bool present: false
    property int percentage

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            const device = UPower.displayDevice
            present = device.isLaptopBattery
            percentage = device.percentage * 100
        }
    }
}
