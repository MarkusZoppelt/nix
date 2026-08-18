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

    Connections {
        target: panel
        function onOpenChanged() {
            if (Bluetooth.defaultAdapter)
                Bluetooth.defaultAdapter.discovering = panel.open;
        }
    }

    PanelCard {
        id: panel
        paneWidth: 360

        Heading {
            title: "Bluetooth"
            subtitle: Bluetooth.defaultAdapter?.enabled ? (Bluetooth.defaultAdapter.discovering ? "scanning" : "on") : "off"
        }

        Pills {
            binary: true
            on: !!Bluetooth.defaultAdapter?.enabled
            onToggled: v => {
                if (Bluetooth.defaultAdapter)
                    Bluetooth.defaultAdapter.enabled = v;
            }
        }

        Section {
            visible: Bluetooth.devices.values.length > 0
            title: "DEVICES"

            Repeater {
                model: Bluetooth.devices

                Choice {
                    required property var modelData
                    title: modelData.name || modelData.deviceName || "device"
                    subtitle: (modelData.connected ? "connected" : modelData.paired ? "paired" : "seen") + (modelData.batteryAvailable ? " · " + Math.round(modelData.battery * 100) + "%" : "")
                    current: modelData.connected
                    accent: Theme.blue
                    onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                }
            }
        }
    }
}
