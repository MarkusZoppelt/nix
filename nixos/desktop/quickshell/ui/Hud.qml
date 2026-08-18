import QtQuick
import ".."

Item {
    id: root
    property var accent
    property real dragX: -1
    property real dragY: -1
    property bool pop: true
    default property alias body: inner.data
    signal dragged(real x, real y)

    width: 720
    implicitHeight: 200
    height: implicitHeight
    x: dragX >= 0 ? dragX : parent ? Math.round((parent.width - width) / 2) : 0
    y: dragY >= 0 ? dragY : 132
    opacity: pop ? 0 : 1
    scale: pop ? 0.94 : 1

    function clamp(nx, ny) {
        const maxX = (parent ? parent.width : width) - width - 8;
        const maxY = (parent ? parent.height : height) - height - 8;
        dragged(Math.max(8, Math.min(maxX, nx)), Math.max(8, Math.min(maxY, ny)));
    }

    property real ox: 0
    property real oy: 0

    function grab(event) {
        ox = event.x;
        oy = event.y;
        if (dragX < 0)
            clamp(x, y);
    }

    function move(event) {
        clamp(x + event.x - ox, y + event.y - oy);
    }

    Component.onCompleted: {
        if (pop) {
            opacity = 1;
            scale = 1;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutBack
        }
    }

    MouseArea {
        id: grip
        anchors.fill: card
        anchors.margins: -18
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        onPressed: event => root.grab(event)
        onPositionChanged: event => {
            if (pressed)
                root.move(event);
        }
    }

    Rectangle {
        anchors.fill: card
        anchors.margins: -18
        radius: 32
        color: "transparent"
        border.width: 1
        border.color: Qt.alpha(root.accent || Theme.cyan, 0.12)
    }

    Rectangle {
        anchors.fill: card
        anchors.margins: -8
        radius: 26
        color: Qt.alpha(root.accent || Theme.cyan, 0.06)
    }

    Rectangle {
        id: card
        width: parent.width
        implicitHeight: root.implicitHeight
        radius: 22
        color: Theme.bg
        border.width: 1
        border.color: Qt.alpha(root.accent || Theme.cyan, 0.45)

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 160
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: event => root.grab(event)
            onPositionChanged: event => {
                if (pressed)
                    root.move(event);
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: Qt.alpha(Theme.fg, 0.22)
        }

        Item {
            id: inner
            anchors.fill: parent
        }
    }
}
