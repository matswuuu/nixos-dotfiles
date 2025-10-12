import QtQuick
import Quickshell
import "./modules/media/"

ShellRoot {
  Scope {
    id: root

    Variants {
      model: [Quickshell.screens[0]]

        Bar {
          id: bar

          // VolumeOverlay {
          //   anchor {
          //     window: bar
          //   } 
          // }
        }      
    }
  }

  // MediaWindow {}
}