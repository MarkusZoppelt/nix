import QtQuick
import Quickshell
import ".."
import "../ui"

Chip {
    id: root
    color: Theme.blue
    text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm")
    tip: Qt.formatDate(clock.date, "dddd, d MMMM yyyy")
    onClicked: cal.toggle(root)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PanelCard {
        id: cal
        paneWidth: 268

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(clock.date, "MMMM yyyy")
            color: Theme.blue
            font.family: Theme.font
            font.pixelSize: 14
        }

        Grid {
            columns: 7
            rowSpacing: 4
            columnSpacing: 4
            width: parent.width

            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                Text {
                    required property string modelData
                    width: 30
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    color: Theme.comment
                    font.family: Theme.font
                    font.pixelSize: 11
                }
            }

            Repeater {
                model: {
                    const d = clock.date;
                    const first = new Date(d.getFullYear(), d.getMonth(), 1);
                    const start = (first.getDay() + 6) % 7;
                    const last = new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate();
                    const cells = [];
                    for (let i = 0; i < start; i++)
                        cells.push(0);
                    for (let day = 1; day <= last; day++)
                        cells.push(day);
                    return cells;
                }

                Text {
                    required property int modelData
                    width: 30
                    height: 22
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: modelData || ""
                    color: modelData === clock.date.getDate() ? Theme.bg : Theme.fg
                    font.family: Theme.font
                    font.pixelSize: 13

                    Rectangle {
                        z: -1
                        visible: modelData === clock.date.getDate()
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        radius: 11
                        color: Theme.blue
                    }
                }
            }
        }
    }
}
