import QtQuick
import Quickshell
import Quickshell.Services.UPower
import ".."
import "../ui"

Chip {
    id: root
    text: "󰻠 " + Stats.cpuPct + "  󰍛 " + Stats.memUsed
    tip: Stats.tip
    onClicked: button => {
        if (button === Qt.RightButton)
            Quickshell.execDetached(["ghostty", "+new-window", "-e", "btop"]);
        else
            panel.toggle(root);
    }

    Connections {
        target: panel
        function onOpenChanged() {
            Stats.hot = panel.open;
        }
    }

    PanelCard {
        id: panel
        paneWidth: 760

        Heading {
            title: Stats.host || "System"
            subtitle: [Stats.kernel, "up " + Stats.uptime, Stats.profileName].filter(s => s && s !== "up —").join(" · ")
        }

        Pills {
            current: Stats.profileName
            items: [{
                    id: "Power Saver",
                    name: "Saver"
                }, {
                    id: "Balanced",
                    name: "Balanced"
                }, {
                    id: "Performance",
                    name: "Perf"
                }].filter(p => p.id !== "Performance" || PowerProfiles.hasPerformanceProfile)
            onPicked: id => Stats.setProfile(id)
        }

        Section {
            title: "MACHINE"

            StatRow {
                label: "CPU"
                value: Stats.cpuPct + (Stats.cores ? " · " + Stats.cores + "c" : "") + (Stats.load !== "—" ? " · " + Stats.load : "")
                ratio: Stats.cpuN
            }

            StatRow {
                label: "RAM"
                value: Stats.memUsed + " / " + Stats.memTotal
                ratio: Stats.memN
            }

            StatRow {
                label: "Swap"
                value: Stats.swapUsed + " / " + Stats.swapTotal
                ratio: Stats.swapN
            }

            StatRow {
                visible: Stats.nvidia
                label: "GPU"
                value: Stats.gpu
                ratio: Stats.gpuN
            }
        }

        Row {
            visible: Stats.cpuTop.length > 0 || Stats.memTop.length > 0
            width: parent.width
            spacing: 10

            Rank {
                width: (parent.width - 10) / 2
                title: "TOP CPU"
                ink: Theme.blue
                rows: Stats.cpuTop
            }

            Rank {
                width: (parent.width - 10) / 2
                title: "TOP RAM"
                ink: Theme.magenta
                rows: Stats.memTop
            }
        }

        Well {
            visible: Stats.nvidia
            ink: Theme.green

            Row {
                width: parent.width
                spacing: 0

                Gauge {
                    width: parent.width / 5
                    value: Stats.gpuN
                    label: "COMPUTE"
                    ink: Theme.green
                }

                Gauge {
                    width: parent.width / 5
                    value: Stats.pwrN
                    label: "POWER"
                    readout: Math.round(Stats.pwrN * 100) + "%"
                    detail: Stats.gpuPwr
                    ink: Theme.green
                }

                Gauge {
                    width: parent.width / 5
                    value: Stats.vramN
                    label: "VRAM"
                    readout: Math.round(Stats.vramN * 100) + "%"
                    detail: Stats.gpuVram
                    ink: Theme.green
                }

                Gauge {
                    width: parent.width / 5
                    value: Stats.encN
                    label: "ENCODER"
                    ink: Theme.green
                }

                Gauge {
                    width: parent.width / 5
                    value: Stats.decN
                    label: "DECODER"
                    ink: Theme.green
                }
            }

            Rank {
                title: "VRAM"
                ink: Theme.green
                rows: Stats.vramTop
                slots: 4
            }
        }

        Section {
            visible: Stats.disks.length > 0
            title: "DISKS"

            Repeater {
                model: Stats.disks

                StatRow {
                    required property var modelData
                    label: modelData.mount
                    value: Math.round(modelData.usage * 100) + "%"
                    ratio: modelData.usage
                    detail: Fmt.bytes(modelData.used) + " used · " + Fmt.bytes(modelData.free) + " free · " + Fmt.bytes(modelData.total) + " · " + modelData.fstype
                }
            }
        }
    }
}
