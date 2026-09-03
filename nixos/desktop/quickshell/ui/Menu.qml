import QtQuick
import Quickshell
import ".."

Item {
    id: root
    property var items: []
    property Item at: null
    property var accent
    signal picked(var item)
    width: 0
    height: 0

    function open(anchor) {
        Tooltip.hide();
        Popups.show(root);
        at = anchor;
        win.visible = true;
    }

    function close() {
        win.visible = false;
        Popups.hide(root);
    }

    PopupWindow {
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
            implicitWidth: Math.max(entries.implicitWidth + 16, 180)
            implicitHeight: entries.implicitHeight + 16
            color: Theme.bg
            radius: Theme.radius
            border.width: 1
            border.color: Theme.black

            Column {
                id: entries
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2

                Repeater {
                    model: root.items

                    Rectangle {
                        required property var modelData
                        width: parent.width
                        implicitHeight: modelData.separator ? 9 : 32
                        radius: 6
                        color: !modelData.separator && hover.containsMouse ? Qt.alpha(root.accent || Theme.blue, 0.22) : "transparent"

                        Rectangle {
                            visible: !!modelData.separator
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 1
                            color: Theme.black
                        }

                        Text {
                            visible: !modelData.separator
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            verticalAlignment: Text.AlignVCenter
                            text: modelData.text || ""
                            textFormat: Text.PlainText
                            color: modelData.danger ? Theme.red : (modelData.enabled === false ? Theme.comment : Theme.fg)
                            font.family: Theme.font
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: hover
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !modelData.separator && modelData.enabled !== false
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.picked(modelData);
                                root.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
