import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"
import "./../utils/"

WrapperRectangle {
    readonly property var theme: Themes.active

    color: theme.backgroundColor2
    radius: theme.borderRadius
    margin: theme.margin

    ColumnLayout {
        spacing: 4

        StyledText {
            text: [
                `IP: ${IpInfo.ip}`,
                `Country: ${IpInfo.country}, ${IpInfo.city} (${IpInfo.countryCode})`,
                `Timezone: ${IpInfo.timezone}`,
                `ISP: ${IpInfo.isp}`
            ].join("\n")
        }
    }
}