pragma Singleton

import Quickshell

Singleton {
    property Theme dark: Theme {
        // backgroundColor: "#121212"
        backgroundColor: "red"
        textColor: "white"
    }

    property var active: dark
}