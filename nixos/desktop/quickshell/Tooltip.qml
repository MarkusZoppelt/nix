pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root
    property string text: ""
    property var at: null

    function show(item, value) {
        if (!item)
            return;
        at = item;
        text = value;
    }

    function hide() {
        text = "";
    }

    PopupWindow {
        visible: root.text !== "" && root.at
        color: "transparent"
        implicitWidth: box.implicitWidth
        implicitHeight: box.implicitHeight
        anchor.item: root.at
        anchor.edges: Edges.Bottom | Edges.Left
        anchor.gravity: Edges.Bottom | Edges.Left

        Rectangle {
            id: box
            implicitWidth: label.implicitWidth + 16
            implicitHeight: label.implicitHeight + 12
            color: Theme.bg
            radius: Theme.radius
            border.width: 1
            border.color: Theme.black

            Text {
                id: label
                anchors.centerIn: parent
                text: root.text
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: 13
            }
        }
    }
}
