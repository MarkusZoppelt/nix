import QtQuick
import Quickshell
import ".."

Item {
    id: root
    required property var modelData
    required property int index
    property bool active: false
    property bool pinned: false
    property var accent
    signal hovered
    signal activated

    width: ListView.view ? ListView.view.width : (parent ? parent.width : 680)
    height: 58

    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 14
        color: root.active ? "transparent" : (root.index % 2 ? Qt.alpha(Theme.bgHighlight, 0.18) : "transparent")
    }

    Text {
        id: idx
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        text: String(root.index + 1).padStart(2, "0")
        color: root.active ? (root.accent || Theme.cyan) : Theme.comment
        font.family: Theme.font
        font.pixelSize: 11
    }

    Rectangle {
        id: well
        anchors.left: idx.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: 40
        height: 40
        radius: 12
        color: Qt.alpha(Theme.bgDark, 0.9)
        border.width: 1
        border.color: root.active ? Qt.alpha(root.accent || Theme.cyan, 0.4) : Qt.alpha(Theme.black, 0.8)

        Image {
            anchors.centerIn: parent
            width: 24
            height: 24
            sourceSize.width: 24
            sourceSize.height: 24
            fillMode: Image.PreserveAspectFit
            source: root.modelData.icon ? Quickshell.iconPath(root.modelData.icon, true) : ""
        }
    }

    Column {
        anchors.left: well.right
        anchors.right: meta.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 2

        Text {
            width: parent.width
            elide: Text.ElideRight
            text: root.modelData.name
            color: root.active ? Theme.fg : Theme.fgDark
            font.family: Theme.font
            font.pixelSize: 16
        }

        Text {
            width: parent.width
            elide: Text.ElideRight
            visible: !!root.modelData.hint
            text: root.modelData.hint
            color: Theme.comment
            font.family: Theme.font
            font.pixelSize: 11
        }
    }

    Column {
        id: meta
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        Rectangle {
            visible: root.pinned
            width: tag.implicitWidth + 10
            height: 16
            radius: 8
            color: Qt.alpha(root.accent || Theme.cyan, 0.16)
            anchors.right: parent.right

            Text {
                id: tag
                anchors.centerIn: parent
                text: "PIN"
                color: root.accent || Theme.cyan
                font.family: Theme.font
                font.pixelSize: 9
            }
        }

        Text {
            anchors.right: parent.right
            visible: !!root.modelData.hint && !root.pinned
            text: "↵"
            color: root.active ? (root.accent || Theme.cyan) : "transparent"
            font.pixelSize: 14
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPositionChanged: root.hovered()
        onClicked: {
            root.hovered();
            root.activated();
        }
    }
}
