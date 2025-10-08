pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    function floorValue(map, value) {
        const keys = Object.keys(map).map(Number).sort((a, b) => a - b)
        let floorKey = 0
        for (let i = 0; i < keys.length; i++) {
            if (value >= keys[i]) floorKey = keys[i]
            else break
        }
        return map[floorKey]
    }
}