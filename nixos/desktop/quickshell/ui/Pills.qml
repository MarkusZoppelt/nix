import QtQuick
import ".."

Row {
    id: root
    property var items: []
    property string current: ""
    property bool binary: false
    property bool on: false
    signal picked(string id)
    signal toggled(bool on)
    readonly property var shown: binary ? [{
            id: "on",
            name: "On"
        }, {
            id: "off",
            name: "Off"
        }] : items
    readonly property string active: binary ? (on ? "on" : "off") : current
    spacing: 8
    width: parent ? parent.width : 360

    Repeater {
        model: root.shown

        Rectangle {
            required property var modelData
            width: (root.width - Math.max(root.shown.length - 1, 0) * root.spacing) / Math.max(root.shown.length, 1)
            implicitHeight: 28
            radius: 6
            color: modelData.id === root.active ? Qt.alpha(Theme.blue, 0.25) : Theme.bgHighlight
            border.width: 1
            border.color: modelData.id === root.active ? Theme.blue : Theme.black

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
                onClicked: {
                    root.picked(modelData.id);
                    if (root.binary)
                        root.toggled(modelData.id === "on");
                }
            }
        }
    }
}
