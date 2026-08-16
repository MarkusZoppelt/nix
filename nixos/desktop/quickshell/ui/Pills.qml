import QtQuick
import ".."

Row {
    id: root
    property var items: []
    property string current: ""
    signal picked(string id)
    spacing: 8
    width: parent ? parent.width : 360

    Repeater {
        model: root.items

        Rectangle {
            required property var modelData
            width: (root.width - Math.max(root.items.length - 1, 0) * root.spacing) / Math.max(root.items.length, 1)
            implicitHeight: 28
            radius: 6
            color: modelData.id === root.current ? Qt.alpha(Theme.blue, 0.25) : Theme.bgHighlight
            border.width: 1
            border.color: modelData.id === root.current ? Theme.blue : Theme.black

            Text {
                anchors.centerIn: parent
                text: modelData.name
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.picked(modelData.id)
            }
        }
    }
}
