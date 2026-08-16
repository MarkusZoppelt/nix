pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

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

    function fmt(n) {
        if (n >= 1e6)
            return (n / 1e6).toFixed(1) + "M";
        if (n >= 1e3)
            return (n / 1e3).toFixed(1) + "K";
        return String(Math.round(n || 0));
    }

    function resetText(iso) {
        const ms = Date.parse(iso) - nowMs;
        if (!(ms > 0))
            return "";
        const m = Math.floor(ms / 60000);
        const h = Math.floor(m / 60);
        const d = Math.floor(h / 24);
        if (d > 0)
            return "Resets in " + d + "d " + (h % 24) + "h";
        if (h > 0)
            return "Resets in " + h + "h " + (m % 60) + "m";
        return "Resets in " + Math.max(1, m) + "m";
    }

    Process {
        id: usageProc
        running: true
        command: ["agent-usage"]
        stdout: StdioCollector {
            onStreamFinished: root.apply(text)
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: usageProc.running = true
    }
}
