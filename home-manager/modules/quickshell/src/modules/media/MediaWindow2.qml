pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Hyprland
import "./../../element/"

Scope {
    id: root
    property bool visible: false
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property var realPlayers: Mpris.players.values.filter(player => isRealPlayer(player))
    readonly property var meaningfulPlayers: filterDuplicatePlayers(realPlayers)
    readonly property real osdWidth: Appearance.sizes.osdWidth
    readonly property real widgetWidth: Appearance.sizes.mediaControlsWidth
    readonly property real widgetHeight: Appearance.sizes.mediaControlsHeight
    property real contentPadding: 13
    property real popupRounding: Appearance.rounding.screenRounding - Appearance.sizes.elevationMargin + 1
    property real artRounding: Appearance.rounding.verysmall
    property list<real> visualizerPoints: []

    property bool hasPlasmaIntegration: false
    Process {
        id: plasmaIntegrationAvailabilityCheckProc
        running: true
        command: ["bash", "-c", "command -v plasma-browser-integration-host"]
        onExited: (exitCode, exitStatus) => {
            root.hasPlasmaIntegration = (exitCode === 0);
        }
    }
    function isRealPlayer(player) {
        return true;
    }

    Process {
        id: cavaProc
        running: mediaControlsLoader.active
        onRunningChanged: {
            if (!cavaProc.running) {
                root.visualizerPoints = [];
            }
        }
        command: ["cava", "-p", `${FileUtils.trimFileProtocol(Directories.scriptPath)}/cava/raw_output_config.txt`]
        stdout: SplitParser {
            onRead: data => {
                // Parse `;`-separated values into the visualizerPoints array
                let points = data.split(";").map(p => parseFloat(p.trim())).filter(p => !isNaN(p));
                root.visualizerPoints = points;
            }
        }
    }

    Loader {
        id: mediaControlsLoader
        active: true
        onActiveChanged: {
            // if (!mediaControlsLoader.active && Mpris.players.values.filter(player => isRealPlayer(player)).length === 0) {
            //     GlobalStates.mediaControlsOpen = false;
            // }
        }

        sourceComponent: PanelWindow {
            id: mediaControlsRoot
            visible: true

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            implicitWidth: root.widgetWidth
            implicitHeight: playerColumnLayout.implicitHeight
            color: "transparent"
            WlrLayershell.namespace: "quickshell:mediaControls"

            anchors {
                top: true
                left: true
                right: true
                // top: !Config.options.bar.bottom || Config.options.bar.vertical
                // bottom: Config.options.bar.bottom && !Config.options.bar.vertical
                // left: !(Config.options.bar.vertical && Config.options.bar.bottom)
                // right: Config.options.bar.vertical && Config.options.bar.bottom
            }
            margins {
                // top: Config.options.bar.vertical ? ((mediaControlsRoot.screen.height / 2) - widgetHeight * 1.5) : Appearance.sizes.barHeight
                // bottom: Appearance.sizes.barHeight
                // left: Config.options.bar.vertical ? Appearance.sizes.barHeight : ((mediaControlsRoot.screen.width / 2) - (osdWidth / 2) - widgetWidth)
                // right: Appearance.sizes.barHeight
            }

            mask: Region {
                item: playerColumnLayout
            }

            HyprlandFocusGrab {
                windows: [mediaControlsRoot]
                active: mediaControlsLoader.active
                onCleared: () => {
                    if (!active) {
                        // GlobalStates.mediaControlsOpen = false;
                    }
                }
            }

            ColumnLayout {
                id: playerColumnLayout
                anchors.fill: parent
                spacing: -Appearance.sizes.elevationMargin // Shadow overlap okay

                // Repeater {
                //     model: ScriptModel {
                //         values: root.meaningfulPlayers
                //     }
                //     delegate: PlayerControl {
                //         required property MprisPlayer modelData
                //         player: modelData
                //         visualizerPoints: root.visualizerPoints
                //         implicitWidth: root.widgetWidth
                //         implicitHeight: root.widgetHeight
                //         radius: root.popupRounding
                //     }
                // }

                Item { // No player placeholder
                    Layout.fillWidth: true
                    visible: root.meaningfulPlayers.length === 0
                    implicitWidth: placeholderBackground.implicitWidth + Appearance.sizes.elevationMargin
                    implicitHeight: placeholderBackground.implicitHeight + Appearance.sizes.elevationMargin

                    Rectangle {
                        // target: placeholderBackground
                    }

                    Rectangle { 
                        id: placeholderBackground
                        anchors.centerIn: parent
                        color: Appearance.colors.colLayer0
                        radius: root.popupRounding
                        property real padding: 20
                        implicitWidth: placeholderLayout.implicitWidth + padding * 2
                        implicitHeight: placeholderLayout.implicitHeight + padding * 2

                        ColumnLayout {
                            id: placeholderLayout
                            anchors.centerIn: parent

                            StyledText {
                                text: Translation.tr("No active player")
                                font.pixelSize: Appearance.font.pixelSize.large
                            }
                            StyledText {
                                color: Appearance.colors.colSubtext
                                text: Translation.tr("Make sure your player has MPRIS support\nor try turning off duplicate player filtering")
                                font.pixelSize: Appearance.font.pixelSize.small
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "mediaControls"

        function toggle(): void {
            mediaControlsLoader.active = !mediaControlsLoader.active;
            if (mediaControlsLoader.active)
                Notifications.timeoutAll();
        }

        function close(): void {
            mediaControlsLoader.active = false;
        }

        function open(): void {
            mediaControlsLoader.active = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "mediaControlsToggle"
        description: "Toggles media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen;
        }
    }
    GlobalShortcut {
        name: "mediaControlsOpen"
        description: "Opens media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = true;
        }
    }
    GlobalShortcut {
        name: "mediaControlsClose"
        description: "Closes media controls on press"

        onPressed: {
            GlobalStates.mediaControlsOpen = false;
        }
    }
}