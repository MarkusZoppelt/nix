import QtQuick
import ".."
import "../ui"

Chip {
    id: root
    color: Tail.up ? Theme.fg : Theme.comment
    text: ""
    tip: [Tail.host, Tail.ip, Tail.exitNode ? "via " + Tail.exitNode.n : "", Tail.up ? Tail.live + "/" + Tail.peers.length + " up" : Tail.state || "tailscale"].filter(Boolean).join(" · ")
    lead: TailMark {
        stroke: root.color
    }
    onClicked: {
        Tail.refresh();
        panel.toggle(root);
    }

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: Tail.host || "Tailscale"
            subtitle: [Tail.dns, Tail.up ? "connected" : (Tail.state || "offline"), Tail.exitNode ? "via " + Tail.exitNode.n : ""].filter(Boolean).join(" · ")
        }

        Pills {
            binary: true
            on: Tail.up
            onToggled: v => {
                if (v !== Tail.up)
                    Tail.toggle();
            }
        }

        Section {
            visible: Tail.ip !== ""
            title: "NODE"

            StatRow {
                label: "Address"
                value: Tail.ip
            }

            StatRow {
                label: "Online"
                value: Tail.live + " / " + Tail.peers.length
            }
        }

        Section {
            visible: Tail.up
            title: "EXIT NODE"

            Pills {
                binary: true
                on: !!Tail.exit
                onToggled: v => {
                    if (v !== !!Tail.exit)
                        Tail.toggleExit();
                }
            }

            Repeater {
                model: Tail.exits

                Choice {
                    required property var modelData
                    title: modelData.n
                    subtitle: [modelData.on ? "up" : "down", modelData.ip].filter(Boolean).join(" · ")
                    glyph: "󰖂"
                    current: modelData.exit || modelData.ip === Tail.exit
                    accent: Theme.orange
                    onClicked: Tail.setExit(modelData.exit || modelData.ip === Tail.exit ? "" : modelData.ip)
                }
            }
        }

        Section {
            visible: Tail.peers.length > 0
            title: "MACHINES"

            Repeater {
                model: Tail.peers

                Choice {
                    required property var modelData
                    title: modelData.n
                    subtitle: [modelData.on ? "up" : "down", modelData.os, modelData.ip].filter(Boolean).join(" · ")
                    glyph: Tail.glyph(modelData.os)
                    current: modelData.on
                    accent: Theme.cyan
                    onClicked: Tail.copy(modelData.ip || modelData.n)
                }
            }
        }
    }
}
