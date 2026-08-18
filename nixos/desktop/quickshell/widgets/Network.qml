import QtQuick
import Quickshell.Networking
import ".."
import "../ui"

Chip {
    id: root
    color: Net.active?.connected ? Theme.fg : Theme.comment
    text: Net.icon()
    tip: [Net.ssid || (Net.wired?.connected ? "ethernet" : "offline"), Net.rx + "↓", Net.tx + "↑"].filter(Boolean).join(" · ")
    onClicked: button => {
        if (button === Qt.RightButton)
            Networking.wifiEnabled = !Networking.wifiEnabled;
        else {
            Net.scan(true);
            panel.toggle(root);
        }
    }

    property var secretNet: null

    Connections {
        target: panel
        function onOpenChanged() {
            Net.scan(panel.open);
            if (!panel.open)
                root.secretNet = null;
        }
    }

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: Net.ssid || (Net.wired?.connected ? "Ethernet" : "Network")
            subtitle: Net.active?.connected ? (Net.rx + " ↓  " + Net.tx + " ↑") : (Networking.wifiEnabled ? "wifi idle" : "wifi off")
        }

        Pills {
            visible: !!Net.wifi
            binary: true
            on: Networking.wifiEnabled
            onToggled: v => Networking.wifiEnabled = v
        }

        Section {
            title: "THROUGHPUT"

            StatRow {
                label: "Down"
                value: Net.rx
            }

            StatRow {
                label: "Up"
                value: Net.tx
            }
        }

        Section {
            visible: Net.addrs.length > 0
            title: "LINKS"

            Repeater {
                model: Net.addrs

                StatRow {
                    required property var modelData
                    label: modelData.n
                    value: modelData.ip || modelData.st || "—"
                }
            }
        }

        Section {
            visible: !!Net.wifi && Networking.wifiEnabled
            title: "WI-FI"

            Repeater {
                model: Net.nets

                Column {
                    required property var modelData
                    width: parent ? parent.width : 352
                    spacing: 6

                    Choice {
                        title: modelData.name || "hidden"
                        subtitle: (modelData.connected ? "connected" : modelData.known ? "saved" : Net.locked(modelData) ? "secured" : "open") + " · " + Math.round((modelData.signalStrength || 0) * 100) + "%"
                        glyph: Net.bars(modelData.signalStrength)
                        current: modelData.connected
                        busy: modelData.stateChanging
                        accent: Theme.blue
                        onClicked: button => {
                            if (button === Qt.RightButton && modelData.known && !modelData.connected)
                                return modelData.forget();
                            if (modelData.connected)
                                return modelData.disconnect();
                            if (modelData.known || !Net.locked(modelData))
                                return modelData.connect();
                            if (root.secretNet === modelData)
                                root.secretNet = null;
                            else {
                                root.secretNet = modelData;
                                secret.text = "";
                                secret.forceActiveFocus();
                            }
                        }
                    }

                    Field {
                        id: secret
                        visible: root.secretNet === modelData
                        width: parent.width
                        placeholderText: "passphrase"
                        echoMode: TextInput.Password
                        onAccepted: {
                            if (root.secretNet && text)
                                root.secretNet.connectWithPsk(text);
                            root.secretNet = null;
                            text = "";
                        }
                    }
                }
            }
        }
    }
}
