import QtQuick
import ".."

Item {
    id: root
    property real value: 0
    property bool muted: false
    property var accent
    signal moved(real value)
    implicitHeight: 10
    width: parent ? parent.width : 360

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.bgHighlight
    }

    Rectangle {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        radius: height / 2
        width: parent.width * Math.max(0, Math.min(1, root.value))
        color: root.muted ? Theme.comment : (root.accent || Theme.cyan)
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: event => root.moved(Math.max(0, Math.min(1, event.x / Math.max(width, 1))))
        onPositionChanged: event => {
            if (pressed)
                root.moved(Math.max(0, Math.min(1, event.x / Math.max(width, 1))));
        }
        onWheel: event => root.moved(Math.max(0, Math.min(1, root.value + (event.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
}
