pragma Singleton

import Quickshell

Singleton {
    property Theme dark: Theme {
        backgroundColor: "#222233"
        textColor: "#e0e0e0"
    }

    property var active: dark
}