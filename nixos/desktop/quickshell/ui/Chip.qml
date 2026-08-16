import QtQuick
import ".."

Item {
    id: root
    property alias text: label.text
    property alias color: label.color
    property alias elide: label.elide
    property real maxWidth: -1
    property bool marquee: false
    property string tip
    signal clicked(int button)
    signal wheeled(int dy)

    implicitWidth: maxWidth > 0 ? Math.min(label.fullWidth + 10, maxWidth) : label.fullWidth + 10
    implicitHeight: Theme.barHeight - 8
    clip: true

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: mouse.containsMouse ? Theme.bgHighlight : "transparent"
    }

    Text {
        id: label
        readonly property real fullWidth: implicitWidth
        anchors.verticalCenter: parent.verticalCenter
        x: 5
        width: root.maxWidth > 0 ? Math.min(fullWidth, root.maxWidth - 10) : fullWidth
        elide: root.maxWidth > 0 && !scroll.running ? Text.ElideRight : Text.ElideNone
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 15
    }

    SequentialAnimation {
        id: scroll
        loops: Animation.Infinite
        PauseAnimation {
            duration: 400
        }
        NumberAnimation {
            target: label
            property: "x"
            from: 5
            to: Math.min(5, root.width - 5 - label.fullWidth)
            duration: Math.max(1600, (label.fullWidth - root.width + 10) * 30)
            easing.type: Easing.Linear
        }
        PauseAnimation {
            duration: 600
        }
        ScriptAction {
            script: label.x = 5
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: event => root.clicked(event.button)
        onWheel: event => root.wheeled(event.angleDelta.y)
        onEntered: {
            if (root.marquee && root.maxWidth > 0 && label.fullWidth + 10 > root.maxWidth) {
                label.width = label.fullWidth;
                scroll.restart();
            } else if (root.tip !== "")
                Tooltip.show(root, root.tip);
        }
        onExited: {
            scroll.stop();
            label.x = 5;
            if (root.maxWidth > 0)
                label.width = Math.min(label.fullWidth, root.maxWidth - 10);
            Tooltip.hide();
        }
    }
}
