import QtQuick
import Quickshell
import Quickshell.Wayland
import "ui"
import "widgets"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: Qt.alpha(Theme.bg, 0.86)
            implicitHeight: Theme.barHeight
            exclusiveZone: Theme.barHeight
            WlrLayershell.namespace: "bar"
            anchors {
                top: true
                left: true
                right: true
            }

            Eq {
                values: Audio.eq
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: Theme.pad
                anchors.rightMargin: Theme.pad
                implicitHeight: 16
                z: 0
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Theme.black
            }

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.pad
                spacing: 4
                Workspaces {}
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                Clock {}
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: Theme.pad
                spacing: 4
                Media {}
                Volume {}
                Blue {}
                Battery {}
                Network {}
                Tailnet {}
                Syncthing {}
                Sysinfo {}
                Agents {}
                Tray {}
                Seal {}
                Power {}
            }
        }
    }
}
