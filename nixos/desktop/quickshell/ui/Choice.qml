import QtQuick
import ".."

Rectangle {
    id: root
    property string title
    property string subtitle
    property string glyph
    property bool current: false
    property bool busy: false
    property var accent
    signal clicked(int button)

    width: parent ? parent.width : 360
    implicitHeight: 44
    radius: 8
    color: current ? Qt.alpha(accent || Theme.blue, 0.2) : (hover.containsMouse ? Theme.bgHighlight : "transparent")
    border.width: 1
    border.color: current ? (accent || Theme.blue) : Theme.black
    opacity: busy ? 0.6 : 1

    Text {
        id: mark
        visible: glyph !== ""
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        text: glyph
        color: current ? (accent || Theme.blue) : Theme.fg
        font.family: Theme.font
        font.pixelSize: 15
    }

    Column {
        anchors.left: mark.visible ? mark.right : parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: mark.visible ? 8 : 10
        anchors.rightMargin: 10
        spacing: 1

        Text {
            width: parent.width
            elide: Text.ElideRight
            text: root.title
            color: Theme.fg
            font.family: Theme.font
            font.pixelSize: 14
        }

        Text {
            visible: root.subtitle !== ""
            width: parent.width
            elide: Text.ElideRight
            text: root.subtitle
            color: Theme.comment
            font.family: Theme.font
            font.pixelSize: 11
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: event => root.clicked(event.button)
    }
}
