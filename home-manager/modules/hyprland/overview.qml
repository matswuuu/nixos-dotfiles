import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root
    // implicitWidth: 1920
    // implicitHeight: 1080
    implicitWidth: 900
    implicitHeight: 480
    exclusionMode: PanelWindow.Exclusive

    property int currentIndex: 0


    property var windowList: []


    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        running: true
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                root.windowList = JSON.parse(clientsCollector.text)
                print(windowList)
                print(windowList)
                print(windowList)
                print(windowList)
                reloadWindows()
            }
        }
    }



    // -------------------------
    // WINDOW MODEL
    // -------------------------
    ListModel {
        id: windowsModel
    }

    function reloadWindows() {
        windowsModel.clear()
        for (const c of windowList) {
            print(JSON.stringify(c))
            if (!c.mapped) continue
            windowsModel.append({
                title: c.title,
                address: c.address,
                className: c.class,
                workspace: c.workspace.id
            })
        }
    }

    Component.onCompleted: reloadWindows()

    // -------------------------
    // BACKGROUND
    // -------------------------
    Rectangle {
        anchors.fill: parent
        color: "#AA000000"
    }

    // -------------------------
    // GRID
    // -------------------------
    GridView {
        id: grid
        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.75

        cellWidth: 320
        cellHeight: 200
        model: windowsModel
        currentIndex: root.currentIndex
        focus: true

        delegate: Rectangle {
            width: 300
            height: 180
            radius: 14

            color: GridView.isCurrentItem ? "#4C8BF5" : "#222"
            border.color: GridView.isCurrentItem ? "#8AB4FF" : "#444"
            border.width: 2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: model.title.length > 0 ? model.title : "(untitled)"
                    color: "white"
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: model.className + " · ws " + model.workspace
                    color: "#BBBBBB"
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: "#111"

                    Text {
                        anchors.centerIn: parent
                        text: "preview"
                        color: "#555"
                        font.pixelSize: 14
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Hyprland.dispatch("focuswindow address:" + model.address)
                }
            }
        }
    }

    // -------------------------
    // KEYBOARD HANDLING
    // -------------------------
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape) {
            Qt.quit()
            event.accepted = true
            return
        }

        if (event.key === Qt.Key_Tab) {
            currentIndex = (currentIndex + 1) % windowsModel.count
            event.accepted = true
            return
        }

        if (event.key === Qt.Key_Backtab) {
            currentIndex =
                (currentIndex - 1 + windowsModel.count) % windowsModel.count
            event.accepted = true
            return
        }

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            const item = windowsModel.get(currentIndex)
            Hyprland.dispatch("focuswindow address:" + item.address)
            Qt.quit()
            event.accepted = true
            return
        }
    }
}
