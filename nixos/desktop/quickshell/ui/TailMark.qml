import QtQuick
import ".."

Item {
    id: root
    property var stroke
    width: 15
    height: 15
    implicitWidth: 15
    implicitHeight: 15

    readonly property real d: 3.6
    readonly property real g: (15 - d) / 2

    Repeater {
        model: 9
        Rectangle {
            required property int index
            width: root.d
            height: root.d
            radius: width / 2
            x: (index % 3) * root.g
            y: Math.floor(index / 3) * root.g
            color: root.stroke || Theme.fg
            opacity: index === 3 || index === 4 || index === 5 || index === 7 ? 1 : 0.28
        }
    }
}
