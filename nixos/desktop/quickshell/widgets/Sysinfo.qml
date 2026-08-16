import QtQuick
import Quickshell.Services.UPower
import ".."
import "../ui"

Chip {
    id: root
    text: "󰻠 " + Stats.cpuPct + "  󰍛 " + Stats.memUsed
    tip: Stats.tip
    onClicked: panel.toggle(root)

    PanelCard {
        id: panel
        paneWidth: 420

        Heading {
            title: Stats.host || "System"
            subtitle: [Stats.kernel, "up " + Stats.uptime, Stats.profileName].filter(s => s && s !== "up —").join(" · ")
        }

        Row {
            width: parent.width
            spacing: 10

            Spark {
                width: (parent.width - 10) / 2
                implicitHeight: 28
                points: Stats.cpuHist
                stroke: Theme.blue
            }

            Spark {
                width: (parent.width - 10) / 2
                implicitHeight: 28
                points: Stats.memHist
                stroke: Theme.magenta
            }
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
                visible: Stats.gpu !== ""
                label: "GPU"
                value: Stats.gpu
                ratio: Stats.gpuN
            }
        }

        Section {
            title: "PROFILE"

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
        }

        Section {
            visible: Stats.disks.length > 0
            title: "DISKS"

            Repeater {
                model: Stats.disks

                Column {
                    required property var modelData
                    width: parent ? parent.width : 392
                    spacing: 4

                    StatRow {
                        label: modelData.mount
                        value: Math.round(modelData.usage * 100) + "%"
                        ratio: modelData.usage
                    }

                    Text {
                        width: parent.width
                        text: Stats.bytes(modelData.used) + " used · " + Stats.bytes(modelData.free) + " free · " + Stats.bytes(modelData.total) + " · " + modelData.fstype
                        color: Theme.comment
                        font.family: Theme.font
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
