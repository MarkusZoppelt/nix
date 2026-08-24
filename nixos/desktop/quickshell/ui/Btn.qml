import QtQuick
import ".."

Rectangle {
    id: root
    property string text
    property string glyph
    property string kind: "ghost"
    property bool enabled: true
    signal clicked

    readonly property var ink: kind === "danger" ? Theme.red : Theme.blue
    implicitHeight: 32
    implicitWidth: Math.max(88, row.implicitWidth + 20)
    radius: 8
    opacity: enabled ? 1 : 0.45
    color: kind === "primary" ? Qt.alpha(ink, hover.containsMouse ? 0.35 : 0.22) : (hover.containsMouse ? Theme.bgHighlight : "transparent")
    border.width: 1
    border.color: kind === "ghost" ? Theme.black : ink

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: root.glyph !== ""
            text: root.glyph
            color: root.kind === "primary" ? root.ink : Theme.fg
            font.family: Theme.font
            font.pixelSize: 14
        }

        Text {
            visible: root.text !== ""
            text: root.text
            textFormat: Text.PlainText
            color: root.kind === "danger" ? Theme.red : Theme.fg
            font.family: Theme.font
            font.pixelSize: 13
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
