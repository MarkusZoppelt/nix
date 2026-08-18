import QtQuick
import Quickshell
import ".."

Item {
    id: root
    property Item at: null
    property real paneWidth: 400
    property real paneMaxHeight: 0
    property bool open: win.visible
    default property alias body: col.data
    width: 0
    height: 0

    readonly property real screenW: (win.screen && win.screen.width) || (Quickshell.screens[0] && Quickshell.screens[0].width) || 1920
    readonly property real screenH: (win.screen && win.screen.height) || (Quickshell.screens[0] && Quickshell.screens[0].height) || 1080
    readonly property real roomW: Math.max(240, screenW - 24)
    readonly property real roomH: Math.max(200, screenH - Theme.barHeight - 24)
    readonly property real maxH: paneMaxHeight > 0 ? Math.min(paneMaxHeight, roomH) : roomH

    function close() {
        win.visible = false;
        Popups.hide(root);
    }

    function toggle(item) {
        Tooltip.hide();
        if (win.visible)
            return close();
        Popups.show(root);
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
            implicitWidth: Math.min(root.paneWidth, root.roomW)
            implicitHeight: Math.min(flick.contentHeight + 28, root.maxH)
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
                interactive: contentHeight > height

                Column {
                    id: col
                    width: parent.width
                    spacing: 12
                }
            }
        }
    }
}
