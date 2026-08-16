import QtQuick
import Quickshell.Bluetooth
import ".."
import "../ui"

Chip {
    id: root
    visible: !!Bluetooth.defaultAdapter
    color: Bluetooth.defaultAdapter?.enabled ? Theme.blue : Theme.comment
    text: {
        const n = Bluetooth.devices.values.filter(d => d.connected).length;
        return n ? "󰂯 " + n : "󰂯";
    }
    tip: {
        const names = Bluetooth.devices.values.filter(d => d.connected).map(d => d.name || d.deviceName);
        return names.length ? names.join("\n") : (Bluetooth.defaultAdapter?.enabled ? "bluetooth on" : "bluetooth off");
    }
    onClicked: button => {
        if (button === Qt.RightButton && Bluetooth.defaultAdapter)
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
        else
            panel.toggle(root);
    }

    PanelCard {
        id: panel
        paneWidth: 360

        Heading {
            title: "Bluetooth"
            subtitle: Bluetooth.defaultAdapter?.enabled ? (Bluetooth.defaultAdapter.discovering ? "scanning" : "on") : "off"
        }

        Pills {
            current: Bluetooth.defaultAdapter?.enabled ? "on" : "off"
            items: [{
                    id: "on",
                    name: "On"
                }, {
                    id: "off",
                    name: "Off"
                }]
            onPicked: id => {
                if (Bluetooth.defaultAdapter)
                    Bluetooth.defaultAdapter.enabled = id === "on";
            }
        }

        Section {
            visible: Bluetooth.devices.values.length > 0
            title: "DEVICES"

            Repeater {
                model: Bluetooth.devices

                Rectangle {
                    required property var modelData
                    width: parent ? parent.width : 332
                    implicitHeight: 40
                    radius: 6
                    color: modelData.connected ? Qt.alpha(Theme.blue, 0.22) : (hover.containsMouse ? Theme.bgHighlight : "transparent")
                    border.width: 1
                    border.color: modelData.connected ? Theme.blue : Theme.black

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 1

                        Text {
                            width: parent.width
                            elide: Text.ElideRight
                            text: modelData.name || modelData.deviceName || "device"
                            color: Theme.fg
                            font.family: Theme.font
                            font.pixelSize: 14
                        }

                        Text {
                            width: parent.width
                            text: (modelData.connected ? "connected" : modelData.paired ? "paired" : "seen") + (modelData.batteryAvailable ? " · " + Math.round(modelData.battery * 100) + "%" : "")
                            color: Theme.comment
                            font.family: Theme.font
                            font.pixelSize: 12
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.connected)
                                modelData.disconnect();
                            else
                                modelData.connect();
                        }
                    }
                }
            }
        }
    }
}
