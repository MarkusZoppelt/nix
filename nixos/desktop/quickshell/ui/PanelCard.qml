import QtQuick
import Quickshell
import ".."

Item {
    id: root
    property Item at: null
    property real paneWidth: 400
    property bool open: win.visible
    default property alias body: col.data
    width: 0
    height: 0

    function close() {
        win.visible = false;
    }

    function toggle(item) {
        Tooltip.hide();
        if (win.visible) {
            win.visible = false;
            return;
        }
        at = item;
        win.visible = true;
    }

    property PopupWindow popup: PopupWindow {
        id: win
        visible: false
        grabFocus: true
        color: "transparent"
        implicitWidth: box.implicitWidth
        implicitHeight: box.implicitHeight
        anchor.item: root.at
        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom | Edges.Left

        Rectangle {
            id: box
            implicitWidth: root.paneWidth
            implicitHeight: Math.min(flick.contentHeight + 28, 640)
            color: Theme.bg
            radius: Theme.radius
            border.width: 1
            border.color: Theme.black

            Flickable {
                id: flick
                anchors.fill: parent
                anchors.margins: 14
                contentWidth: width
                contentHeight: col.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id: col
                    width: parent.width
                    spacing: 12
                }
            }
        }
    }
}
