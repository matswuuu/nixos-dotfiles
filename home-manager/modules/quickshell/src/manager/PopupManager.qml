pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property Item currentPopup: null

    function registerPopup(popup) {
        if (currentPopup && currentPopup !== popup) {
            currentPopup.forceHide();
        }
        currentPopup = popup;
    }

    function unregisterPopup(popup) {
        if (currentPopup === popup) {
            currentPopup = null;
        }
    }
}
