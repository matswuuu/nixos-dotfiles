import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Widgets
import "./../../element/"
import "./../../utils/"

StyledPopup {
    // readonly property var theme: Themes.active
    property string title
    property string usageText
    property string tempText
    property string tempColor
    property var diagrams: []

    contentItem: WrapperRectangle {
        color: theme.backgroundColor2
        radius: theme.borderRadius
        margin: theme.margin + 4

        ColumnLayout {
            Repeater {
                id: chartRepeater
                model: diagrams.length
                delegate: UsageDiagram {
                    width: 400
                    height: 250

                    paddingLeft: 60
                    paddingRight: 20
                    paddingTop: 10
                    paddingBottom: 40

                    xSteps: 6
                    ySteps: 5

                    lineColor: "#4aa3ff"
                    valueColor: "red"
                    axisColor: "white"
                }
            }
        }
    }

    onDiagramsChanged: {
        // Softly update points to avoid blinking
        for (let i = 0; i < diagrams.length; i++) {
            let item = chartRepeater.itemAt(i)
            if (item) {
                const diagram = diagrams[i]
                item.points = getUsagePoints(diagram.stepX, diagram.maxX, diagram.history)
                item.minY = diagram.minY ? diagram.minY : 0
                item.maxX = diagram.maxX
                item.maxY = diagram.maxY
                item.title = diagram.title
                if (diagram.yFormatter) item.yFormatter = diagram.yFormatter
            }
        }
    }

    RowLayout {
        spacing: 4

        StyledText {
            text: title
        }
        StyledText {
            text: usageText
        }
        StyledText {
            text: tempText
            color: tempColor
        }
    }  
}