import QtQuick
import ".."

Column {
    property string label
    property string value
    property real ratio: -1
    width: parent ? parent.width : 360
    spacing: 4

    Item {
        width: parent.width
        implicitHeight: 18

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: label
            color: Theme.fg
            font.family: Theme.font
            font.pixelSize: 14
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: value
            color: ratio >= 0.9 ? Theme.red : Theme.fg
            font.family: Theme.font
            font.pixelSize: 13
        }
    }

    Meter {
        visible: ratio >= 0
        width: parent.width
        value: ratio
    }
}
