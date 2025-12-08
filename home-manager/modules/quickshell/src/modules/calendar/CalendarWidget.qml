import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "./../../element/"
import "./../../theme/"

WrapperRectangle {
    property int monthOffset: 0
    property var viewingDate: getDate(monthOffset)
    property var currentDate: getDate(0)

    function getDate(offset): Date {
        const date = new Date();
        date.setMonth(date.getMonth() + offset);
        return date;
    }

    WrapperMouseArea {
        onWheel: (mouse) => {
            const delta = mouse.angleDelta;
            if (delta.x < 0 || delta.y > 0) {
                monthOffset++;
            } else if (delta.x > 0 || delta.y < 0) {
                monthOffset--;
            }
        }

        ColumnLayout {
            RowLayout {
                Layout.fillWidth: true

                WrapperMouseArea {
                    onClicked: {
                        monthOffset = 0;
                    }

                    StyledText {
                        text: viewingDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
                    }
                }

                // Spacer
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight

                    SymbolButton {
                        symbol: "chevron_left"
                        onClicked: {
                            monthOffset--;
                        }

                    }
                    SymbolButton {
                        symbol: "chevron_right"
                        onClicked: {
                            monthOffset++;
                        }
                    }
                }
            }

            DayOfWeekRow {
                locale: grid.locale
                spacing: 14
                Layout.fillWidth: true
                Layout.fillHeight: true

                delegate: Text {
                    text: model.shortName
                    Layout.alignment: Qt.AlignHCenter 
                }
            }

            MonthGrid {
                id: grid
                year: viewingDate.getFullYear()
                month: viewingDate.getMonth()
                locale: Qt.locale()

                Layout.preferredWidth: 270
                Layout.preferredHeight: 150
                Layout.fillWidth: true
                Layout.fillHeight: true

                delegate: Rectangle {
                    property bool currentMonth: model.year === currentDate.getFullYear() && model.month === currentDate.getMonth()
                    width: grid.cellWidth
                    height: grid.cellHeight
                    color: currentMonth ? "yellow" : "lightgray"
                    opacity: currentMonth ? 1.0 : 0.4

                    Text {
                        anchors.centerIn: parent
                        text: model.day
                        color: model.today ? "red" : "blue"
                    }
                }
            }
        }
    }
}
