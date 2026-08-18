import QtQuick
import ".."

Rectangle {
    id: root
    property var ink
    default property alias body: col.data
    width: parent ? parent.width : 360
    implicitHeight: col.implicitHeight + 24
    radius: 12
    color: Qt.alpha(ink || Theme.blue, 0.12)
    border.width: 1
    border.color: Qt.alpha(ink || Theme.blue, 0.28)

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        spacing: 10
    }
}
