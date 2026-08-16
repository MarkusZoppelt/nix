import QtQuick
import Quickshell
import ".."
import "../ui"

Chip {
    id: root
    color: AgentUsage.alarming ? Theme.red : Theme.magenta
    text: {
        const w = AgentUsage.headline;
        return w ? "󱚣 " + Math.round(w.percent * 100) + "%" : "󱚣";
    }
    tip: AgentUsage.hint
    onClicked: button => {
        if (button === Qt.RightButton)
            Quickshell.execDetached(["ghostty", "+new-window", "-e", "opencode2"]);
        else {
            AgentUsage.refresh();
            panel.toggle(root);
        }
    }

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: AgentUsage.selected ? AgentUsage.selected.name : "Agents"
            subtitle: AgentUsage.selected ? (AgentUsage.selected.tierLabel || "") : "No subscriptions"
        }

        Pills {
            visible: AgentUsage.providers.length > 1
            current: AgentUsage.selectedId
            items: AgentUsage.providers.map(p => ({
                        id: p.id,
                        name: p.name
                    }))
            onPicked: id => AgentUsage.selectedId = id
        }

        Section {
            visible: AgentUsage.limits.length > 0
            title: "LIMITS"

            Repeater {
                model: AgentUsage.limits

                Column {
                    required property var modelData
                    width: parent ? parent.width : 352
                    spacing: 4

                    StatRow {
                        label: modelData.title
                        value: Math.round((modelData.percent || 0) * 100) + "%"
                        ratio: modelData.percent || 0
                    }

                    Text {
                        visible: text !== ""
                        text: AgentUsage.resetText(modelData.resetsAt)
                        color: Theme.comment
                        font.family: Theme.font
                        font.pixelSize: 12
                    }
                }
            }
        }

        Section {
            visible: AgentUsage.days.length > 0
            title: "TOKENS BY DAY"

            Repeater {
                model: AgentUsage.days

                StatRow {
                    required property var modelData
                    readonly property bool isToday: modelData.date === Qt.formatDate(new Date(AgentUsage.nowMs), "yyyy-MM-dd")
                    readonly property real peak: Math.max(1, ...AgentUsage.days.map(d => Number(d.tokens || 0)))
                    label: isToday ? "Today" : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][new Date(modelData.date + "T00:00:00").getDay()]
                    value: AgentUsage.fmt(modelData.tokens || 0)
                    ratio: Number(modelData.tokens || 0) / peak
                }
            }
        }

        Section {
            visible: AgentUsage.models.length > 0
            title: "TOKENS BY MODEL"

            Repeater {
                model: AgentUsage.models

                StatRow {
                    required property var modelData
                    label: modelData.name
                    value: AgentUsage.fmt(modelData.tokens)
                    ratio: modelData.tokens / Math.max(1, AgentUsage.models[0].tokens)
                }
            }
        }
    }
}
