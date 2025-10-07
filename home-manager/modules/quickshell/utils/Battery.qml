pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: battery

    property bool present: false
    property bool charging: false
    property bool full: false
    property bool onBattery: false
    property int percentage: UPower.displayDevice?.percentage ?? 1
    property string state: "unknown"
    property string iconName: ""
    property var device: null
}
