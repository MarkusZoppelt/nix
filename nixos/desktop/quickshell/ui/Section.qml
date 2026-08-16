import QtQuick
import ".."

Column {
    property alias title: head.text
    width: parent ? parent.width : 360
    spacing: 10

    Text {
        id: head
        color: Theme.comment
        font.family: Theme.font
        font.pixelSize: 11
    }
}
