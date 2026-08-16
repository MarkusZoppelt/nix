import QtQuick
import ".."

Item {
    property real value: 0
    property bool hot: value >= 0.9
    implicitHeight: 4

    Rectangle {
        anchors.fill: parent
        radius: 2
        color: Theme.bgHighlight
    }

    Rectangle {
        anchors.left: parent.left
        height: parent.height
        radius: 2
        width: parent.width * Math.max(0, Math.min(1, value))
        color: hot ? Theme.red : Theme.fg

        Behavior on width {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }
    }
}
