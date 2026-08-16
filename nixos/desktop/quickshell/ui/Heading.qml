import QtQuick
import ".."

Column {
    property alias title: head.text
    property alias subtitle: sub.text
    width: parent ? parent.width : 360
    spacing: 2

    Text {
        id: head
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 18
    }

    Text {
        id: sub
        visible: text !== ""
        color: Theme.comment
        font.family: Theme.font
        font.pixelSize: 13
    }
}
