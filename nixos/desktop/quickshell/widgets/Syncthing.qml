import QtQuick
import ".."
import "../ui"

Chip {
    id: root
    color: Sync.up ? Theme.fg : Theme.comment
    text: ""
    tip: ["syncthing", Sync.summary, Sync.up ? Sync.connected + " devices" : ""].filter(Boolean).join(" · ")
    lead: SyncMark {
        stroke: root.color
        opacity: Sync.up ? 1 : 0.55
    }
    onClicked: {
        Sync.refresh();
        panel.toggle(root);
    }

    PanelCard {
        id: panel
        paneWidth: 420

        Heading {
            title: "Syncthing"
            subtitle: Sync.summary
        }

        Pills {
            binary: true
            on: Sync.up
            onToggled: v => {
                if (v !== Sync.up)
                    Sync.toggle();
            }
        }

        Section {
            visible: Sync.folders.length > 0
            title: "FOLDERS"

            Repeater {
                model: Sync.folders

                Choice {
                    required property var modelData
                    title: modelData.label || modelData.id
                    subtitle: [Sync.labelState(modelData), modelData.local ? Fmt.bytes(modelData.local) : "", modelData.path].filter(Boolean).join(" · ")
                    current: !modelData.paused && !modelData.err
                    accent: modelData.err ? Theme.red : (modelData.state === "syncing" || (modelData.need || 0) > 0 ? Theme.orange : Theme.green)
                    onClicked: Sync.openPath(modelData.path)
                }
            }
        }

        Section {
            visible: Sync.devices.length > 0
            title: "REMOTE DEVICES"

            Repeater {
                model: Sync.devices

                Choice {
                    required property var modelData
                    title: modelData.name
                    subtitle: modelData.on ? "Connected" : "Disconnected"
                    current: modelData.on
                    accent: Theme.blue1
                    glyph: modelData.on ? "󰌘" : "󰌙"
                }
            }
        }

        Choice {
            title: "Open Web UI"
            subtitle: "127.0.0.1:8384"
            glyph: "󰖟"
            accent: Theme.blue1
            onClicked: Sync.openUi()
        }
    }
}
