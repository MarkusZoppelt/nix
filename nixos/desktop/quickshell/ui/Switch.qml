import QtQuick
import ".."

Item {
    id: root
    property string label
    property bool on: false
    property var ink
    signal toggled(bool on)

    width: parent ? parent.width : 360
    implicitHeight: 28

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: track.left
        anchors.rightMargin: 12
        elide: Text.ElideRight
        text: root.label
        textFormat: Text.PlainText
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 14
    }

    Rectangle {
        id: track
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        height: 24
        radius: 12
        color: root.on ? Qt.alpha(root.ink || Theme.blue, 0.35) : Theme.bgHighlight
        border.width: 1
        border.color: root.on ? (root.ink || Theme.blue) : Theme.black

        Rectangle {
            width: 18
            height: 18
            radius: 9
            x: root.on ? track.width - width - 3 : 3
            anchors.verticalCenter: parent.verticalCenter
            color: root.on ? (root.ink || Theme.blue) : Theme.fgDark

            Behavior on x {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggled(!root.on)
        }
    }
}
