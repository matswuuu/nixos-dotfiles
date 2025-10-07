pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick

Singleton {
    property var stateSymbols: {
        0: "󰂲", // nf-md-bluetooth_off
        1: "󰂯", // nf-md-bluetooth
        2: "󰂲", // nf-md-bluetooth_off
        3: "󰂯", // nf-md-bluetooth
        4: "󰂲" // nf-md-bluetooth_off
    }

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    property string stateSymbol: stateSymbols[adapter.state]
}