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

    property var windowByAddress: {}


    property int currentIndex: 0


    function reloadWindows() {
        getClients.running = true;
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                const windows = JSON.parse(clientsCollector.text);
                windowsModel.clear();
                windowByAddress = {};

                let index = 0
                for (const c of windows) {
                    if (!c.mapped) continue

                    c.index = index++;
                    windowByAddress[c.address] = c

                    if (Hyprland.focusedWorkspace.id == c.workspace.id) {
                        maybeCapturePreview(c)
                    }

                    windowsModel.append({
                        title: c.title,
                        address: c.address,
                        className: c.class,
                        workspace: c.workspace.id,
                        preview: ""
                    })
                }
            }
        }
    }


    Connections {
        target: Hyprland

        function onRawEvent(event) {
            print(JSON.stringify(event))
            switch (event.name) {
                case "openwindow":
                    reloadWindows();
                    break;
                case "closewindow":
                    reloadWindows();
                    break;
                case "activewindowv2":
                    const windowAddress = `0x${event.data}`;
                    const window = windowByAddress[windowAddress];
                    maybeCapturePreview(window)
                    break;
            }
        }
    }


    Component {
        id: previewSpawner

        Process {
            property real sizeX
            property real sizeY
            property real posX
            property real posY
            property int modelIndex
            property string output

            command: [
                "grim",
                `-g ${Math.floor(posX)},${Math.floor(posY)} ${Math.floor(sizeX)}x${Math.floor(sizeY)}`,
                output
            ]

            running: true

            stdout: StdioCollector {
                onStreamFinished: {
                    windowsModel.setProperty(modelIndex, "preview", output)
                    destroy()
                }
            }
        }
    }




    // -------------------------
    // WINDOW MODEL
    // -------------------------
    ListModel {
        id: windowsModel
    }

    function maybeCapturePreview(window) {
        print(JSON.stringify(window))
        previewSpawner.createObject(root, { 
            sizeX: window.size[0],
            sizeY: window.size[1],
            posX: window.at[0],
            posY: window.at[1],
            modelIndex: window.index,
            output: `/tmp/hypr-previews/${window.address}.png`
        })
    }

    Component.onCompleted: {
        getClients.running = true;
    }

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

                    Image {
                        anchors.fill: parent
                        source: model.preview
                        asynchronous: true
                        cache: false
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }


                    // Text {
                    //     anchors.centerIn: parent
                    //     text: "preview"
                    //     color: "#555"
                    //     font.pixelSize: 14
                    // }
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
