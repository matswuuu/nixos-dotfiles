import Qt.labs.qmlmodels
import QtQuick
import Quickshell
import Quickshell.Widgets
import "./../../utils/"
import "./../../element/"

TableView {
    // anchors.fill: parent
    implicitWidth: 300
    implicitHeight: 300
    // columnSpacing: 1
    // rowSpacing: 1
    // clip: 

    model: TableModel {
        id: tableModel
        TableModelColumn { display: "pid" }
        TableModelColumn { display: "name" }
        TableModelColumn { display: "percent" }
    }

    delegate: WrapperRectangle {
        margin: 4

        Text {
            text: display
            anchors.centerIn: parent
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 1000
        onTriggered: updateModel()
    }

    function updateModel() {
        if (ProcessUsage.processes.length === 0) return

        tableModel.clear()
        for (const p of ProcessUsage.processes) {
            tableModel.appendRow({
                "pid": p.pid,
                "name": p.name,
                "percent": p.percent
            })
        }
    }
}