pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property string ip: ""
    property string country: ""
    property string countryCode: ""
    property string regionName: ""
    property string city: ""
    property string timezone: ""
    property string isp: ""
    property string org: ""

    Process {
        id: fetchProcess
        running: true
        command: ["curl", "-s", "http://ip-api.com/json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const info = JSON.parse(this.text.trim())
                    ip = info.query || ""
                    country = info.country || ""
                    countryCode = info.countryCode || ""
                    regionName = info.regionName || ""
                    city = info.city || ""
                    timezone = info.timezone || ""
                    isp = info.isp || ""
                    org = info.org || ""
                } catch(e) {
                    console.log("Failed to parse IP info:", e)
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
