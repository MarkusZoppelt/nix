pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Singleton {
    id: root
    property var item: null
    property var at: null

    QsMenuOpener {
        id: opener
        menu: root.item?.menu ?? null
    }

    function open(trayItem, anchor) {
        item = trayItem;
        at = anchor;
    }

    function close() {
        item = null;
    }

    PopupWindow {
        visible: root.item && root.at
        grabFocus: true
        color: "transparent"
        implicitWidth: menu.implicitWidth
        implicitHeight: menu.implicitHeight
        anchor.item: root.at
        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom | Edges.Left

        Rectangle {
            id: menu
            implicitWidth: Math.max(entries.implicitWidth + Theme.pad * 2, 180)
            implicitHeight: entries.implicitHeight + Theme.pad * 2
            color: Theme.bg
            radius: Theme.radius
            border.width: 1
            border.color: Theme.black

            Column {
                id: entries
                anchors.fill: parent
                anchors.margins: Theme.pad
                spacing: 2

                Repeater {
                    model: opener.children

                    Rectangle {
                        required property var modelData
                        width: parent.width
                        implicitHeight: modelData.isSeparator ? 9 : 32
                        radius: 6
                        color: !modelData.isSeparator && hover.containsMouse ? Qt.alpha(Theme.blue, 0.25) : "transparent"

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 1
                            color: Theme.black
                        }

                        Text {
                            visible: !modelData.isSeparator
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            verticalAlignment: Text.AlignVCenter
                            text: modelData.text
                            color: modelData.enabled ? Theme.fg : Theme.comment
                            font.family: Theme.font
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: hover
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !modelData.isSeparator && modelData.enabled
                            onClicked: {
                                modelData.triggered();
                                root.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
