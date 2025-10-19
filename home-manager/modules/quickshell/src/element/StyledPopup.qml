import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "./../utils/"
import "./../theme/"
import "./../manager/"

WrapperMouseArea {
    readonly property Theme theme: Themes.active
    required property var contentItem
    property int hoverCountTrigger: 300

    property bool triggerHovered
    property bool popupHovered
    property int triggerHoverCount

    id: root
    hoverEnabled: true

    onEntered: {
        triggerHovered = true;
        triggerHoverCount = 0;
    }
    onExited: {
        triggerHovered = false;
        hide();
    }

    function show() {
        PopupManager.registerPopup(root)
        fadeAnim.stop();
        appearAnim.start();
        window.visible = true;
    }

    function hide() {
        if (triggerHovered || popupHovered) return;
        appearAnim.stop();
        fadeAnim.restart();
    }

    function forceHide() {
        appearAnim.stop();
        window.visible = false
    }
    
    // Prevent from accidental movements
    Timer {
        interval: 10
        running: triggerHovered
        repeat: true
        onTriggered: {
            triggerHoverCount += interval;
            if (triggerHoverCount == hoverCountTrigger) {
                show();
            }
        }
    }

    PopupWindow {
        id: window
        visible: false
        color: "transparent"
        implicitWidth: wrapper.width
        implicitHeight: wrapper.height
        anchor {
            item: root
            rect.y: root.implicitHeight + 10
        }

        // ShaderEffectSource {
        //     id: effectSource

        //     sourceItem: wrapper
        //     anchors.centerIn: wrapper
        //     width: 400
        //     height: 400
        //     sourceRect: Qt.rect(x,y, width, height)
        // }

        // MultiEffect {
        //     id: blurEffect
        //     anchors.fill: parent
        //     source: effectSource
        //     blurEnabled: true
        //     blur: 0.45            // tweak
        //     brightness: 1.0
        //     saturation: 1.0
        //     colorization: 0.12    // slight tint if you want
        //     colorizationColor: "#00000050"
        //     z: 0
        // }

        MouseArea {
            id: wrapper
            implicitWidth: contentItem.width
            implicitHeight: contentItem.height
            hoverEnabled: true

            onEntered: {
                popupHovered = true;
                show();
            }
            onExited: {
                popupHovered = false;
                hide();
            }

            SequentialAnimation on opacity {
                id: appearAnim
                PropertyAnimation { to: 1; duration: 200 }
            }

            SequentialAnimation on opacity {
                id: fadeAnim
                PropertyAnimation { to: 1; duration: 200 }
                PauseAnimation { duration: 400 }
                PropertyAnimation { to: 0; duration: 200 }
                onFinished: {
                    window.visible = false
                }
            }

            Component.onCompleted: {
                contentItem.parent = wrapper
                contentItem.anchors.fill = wrapper
            }
        }
    }
}
