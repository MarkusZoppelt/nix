pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import "ui"

Singleton {
    id: root
    property bool open: false
    property real value: 0
    property string icon: ""
    property string label: ""

    function show(value, icon, label) {
        root.value = Math.max(0, Math.min(1, Number(value) || 0));
        root.icon = icon || "";
        root.label = label || "";
        open = true;
        hide.restart();
    }

    Timer {
        id: hide
        interval: 900
        onTriggered: root.open = false
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: root.open
            color: "transparent"
            implicitHeight: 80
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "osd"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors {
                left: true
                right: true
                bottom: true
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 36
                implicitWidth: 220
                implicitHeight: 64
                color: Qt.alpha(Theme.bg, 0.94)
                radius: Theme.radius
                border.width: 1
                border.color: Theme.black

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 28
                    spacing: 8

                    Item {
                        width: parent.width
                        implicitHeight: 18

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.icon
                            color: Theme.fg
                            font.family: Theme.font
                            font.pixelSize: 16
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.label
                            color: Theme.comment
                            font.family: Theme.font
                            font.pixelSize: 13
                        }
                    }

                    Meter {
                        width: parent.width
                        value: root.value
                    }
                }
            }
        }
    }
}
