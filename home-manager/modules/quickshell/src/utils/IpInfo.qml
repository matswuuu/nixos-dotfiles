pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property string ip
    property string country
    property string countryCode
    property string city
    property string timezone
    property string isp

    Process {
        id: fetchProcess
        running: true
        command: ["curl", "-s", "http://ip-api.com/json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const info = JSON.parse(this.text.trim())
                    ip = info.query || "?"
                    country = info.country || "?"
                    countryCode = info.countryCode || "?"
                    city = info.city || "?"
                    timezone = info.timezone || "?"
                    isp = `${info.isp} (${info.as})` || "?"
                } catch(e) {
                    console.err1or("Failed to parse IP info:", e)
                }
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            fetchProcess.running = true
        }
    }
}
