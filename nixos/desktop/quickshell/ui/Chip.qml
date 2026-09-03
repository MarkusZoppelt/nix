import QtQuick
import ".."

Item {
    id: root
    property alias text: label.text
    property alias color: label.color
    property string tip
    property alias lead: leadItem.data
    readonly property real leadW: leadItem.implicitWidth
    signal clicked(int button)
    signal wheeled(int dy)

    implicitWidth: leadW + label.implicitWidth + 10
    implicitHeight: Theme.barHeight - 8

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: mouse.containsMouse ? Theme.bgHighlight : "transparent"
    }

    Item {
        id: leadItem
        anchors.left: parent.left
        anchors.leftMargin: implicitWidth ? 5 : 0
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: children.length ? children[0].implicitWidth : 0
        implicitHeight: children.length ? children[0].implicitHeight : 0
        width: implicitWidth
        height: implicitHeight
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        x: 5 + (root.leadW ? root.leadW + 4 : 0)
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: 15
        textFormat: Text.PlainText
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: event => root.clicked(event.button)
        onWheel: event => root.wheeled(event.angleDelta.y)
        onEntered: if (root.tip !== "")
            Tooltip.show(root, root.tip)
        onExited: Tooltip.hide()
    }
}
