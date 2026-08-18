pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "ui"

Singleton {
    id: root
    property string selectedId: ""
    property var providers: []
    property double nowMs: Date.now()
    readonly property var selected: providers.find(p => p.id === selectedId) || providers[0] || null
    readonly property var limits: selected?.limits || []
    readonly property var days: selected?.recentDays || []
    readonly property var models: selected?.models || []
    readonly property bool alarming: limits.some(w => w.percent >= 0.9)
    readonly property var headline: fullest(selected)
    readonly property string hint: providers.map(p => {
        const w = fullest(p);
        return w ? p.name + " · " + Math.round(w.percent * 100) + "% " + w.title : p.name;
    }).join("\n") || "Agents"

    function fullest(p) {
        return (p?.limits || []).reduce((best, w) => !best || w.percent > best.percent ? w : best, null);
    }

    function refresh() {
        nowMs = Date.now();
        usageProc.running = true;
    }

    function apply(text) {
        try {
            const next = JSON.parse(text).providers || [];
            providers = next;
            if (next.length && !next.some(p => p.id === selectedId))
                selectedId = next[0].id;
        } catch (e) {
        }
    }

    Poll {
        id: usageProc
        interval: 900000
        command: ["agent-usage"]
        stdout: StdioCollector {
            onStreamFinished: root.apply(text)
        }
    }
}
