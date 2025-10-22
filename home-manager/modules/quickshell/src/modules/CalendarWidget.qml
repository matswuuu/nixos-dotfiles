import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../element/"
import "./../theme/"

WrapperRectangle {
    color: "red"

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
        }

        MonthGrid {
            id: grid
            month: Calendar.December
            year: 2015
            locale: Qt.locale("en_US")

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
