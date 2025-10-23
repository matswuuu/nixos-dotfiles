import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"

WrapperRectangle {
    color: "yellow"

    GridLayout {
        columns: 2

        DayOfWeekRow {
            locale: grid.locale

            Layout.column: 1
            Layout.fillWidth: true
        }

        WeekNumberColumn {
            month: grid.month
            year: grid.year
            locale: grid.locale

            Layout.fillHeight: true

            delegate: Text {
                text: model.weekNumber
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MonthGrid {
            id: grid
            month: new Date().getMonth()
            year: Calendar.year
            locale: Qt.locale()

            Layout.fillWidth: true
            Layout.fillHeight: true

            delegate: Rectangle {
                width: grid.cellWidth
                height: grid.cellHeight
                color: model.isCurrentMonth ? "white" : "lightgray" // Differentiate previous/next month days
                opacity: model.isCurrentMonth ? 1.0 : 0.5 // Make them slightly faded

                Text {
                    anchors.centerIn: parent
                    text: model.day
                    color: model.isCurrentMonth ? "black" : "darkgray"
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        print(model.weekNumber)
                    }
                }
            }
        }
    }
}
