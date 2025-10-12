pragma Singleton

import Quickshell

Singleton {
    property Theme macchiato: Theme {
        backgroundColor: "#24273a"
        backgroundColor2: "#363a4f"
        interactiveColor: "#c6a0f6"
        textColor: "#cad3f5"
    }

    property var active: macchiato
}