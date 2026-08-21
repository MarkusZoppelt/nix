pragma Singleton
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

    Process {
        id: usageProc
        command: ["agent-usage"]
        stdout: StdioCollector {
            onStreamFinished: root.apply(text)
        }
    }
}
