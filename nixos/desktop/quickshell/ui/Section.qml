import QtQuick
import ".."

Column {
    property alias title: head.text
    property var ink
    width: parent ? parent.width : 360
    spacing: 10

    Item {
        width: parent.width
        implicitHeight: 16

        Rectangle {
            visible: head.text !== ""
            width: 2
            height: 10
            radius: 1
            color: ink || Theme.comment
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: head
            anchors.left: parent.left
            anchors.leftMargin: text !== "" ? 8 : 0
            anchors.verticalCenter: parent.verticalCenter
            color: ink || Theme.comment
            font.family: Theme.font
            font.pixelSize: 11
        }
    }
}
