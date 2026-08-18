pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool up: false
    property string key: ""
    property var folders: []
    property var devices: []
    property int connected: 0
    readonly property int paused: folders.filter(f => f.paused).length
    readonly property int syncing: folders.filter(f => f.state === "syncing" || (f.need || 0) > 0).length
    readonly property string summary: !up ? "stopped" : syncing ? syncing + " syncing" : paused ? paused + " paused" : "up to date"

    function refresh() {
        if (!key)
            keyProc.running = true;
        else
            pull();
    }

    function toggle() {
        console.warn("Sync.toggle", up ? "stop" : "start");
        Quickshell.execDetached(["systemctl", "--user", up ? "stop" : "start", "syncthing.service"]);
        Qt.callLater(refresh);
    }

    function openUi() {
        Quickshell.execDetached(["xdg-open", "http://127.0.0.1:8384"]);
    }

    function openPath(path) {
        if (path)
            Quickshell.execDetached(["xdg-open", path]);
    }

    function labelState(f) {
        if (!f)
            return "";
        if (f.paused)
            return "Paused";
        if (f.err)
            return "Out of Sync";
        if (f.state === "syncing" || (f.need || 0) > 0)
            return "Syncing";
        if (f.state === "scanning")
            return "Scanning";
        return "Up to Date";
    }

    function get(path, ok) {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:8384" + path);
        xhr.setRequestHeader("X-API-Key", key);
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== 4)
                return;
            if (xhr.status < 200 || xhr.status >= 300) {
                root.up = false;
                return;
            }
            try {
                ok(JSON.parse(xhr.responseText));
            } catch (e) {
                root.up = false;
            }
        };
        xhr.send();
    }

    function pull() {
        const box = {
            folders: null,
            devices: null,
            conns: null,
            me: null
        };
        const build = () => {
            if (box.folders === null || box.devices === null || box.conns === null || box.me === null)
                return;
            const online = box.conns.connections || {};
            const others = (box.devices || []).filter(d => d.deviceID !== box.me).map(d => ({
                        id: d.deviceID,
                        name: d.name || d.deviceID,
                        on: !!(online[d.deviceID] && online[d.deviceID].connected)
                    }));
            root.devices = others;
            root.connected = others.filter(d => d.on).length;
            const next = (box.folders || []).map(f => ({
                        id: f.id,
                        label: f.label || f.id,
                        path: f.path,
                        paused: !!f.paused,
                        state: "",
                        need: 0,
                        local: 0,
                        global: 0,
                        err: ""
                    }));
            root.folders = next;
            root.up = true;
            next.forEach((f, i) => {
                root.get("/rest/db/status?folder=" + encodeURIComponent(f.id), s => {
                    const copy = root.folders.slice();
                    copy[i] = Object.assign({}, copy[i], {
                        state: s.state || "",
                        need: s.needBytes || 0,
                        local: s.localBytes || 0,
                        global: s.globalBytes || 0,
                        err: s.error || ""
                    });
                    root.folders = copy;
                });
            });
        };
        get("/rest/config/folders", d => {
            box.folders = d;
            build();
        });
        get("/rest/config/devices", d => {
            box.devices = d;
            build();
        });
        get("/rest/system/connections", d => {
            box.conns = d || {};
            build();
        });
        get("/rest/system/status", d => {
            box.me = d.myID || "";
            build();
        });
    }

    Process {
        id: keyProc
        command: ["syncthing", "cli", "config", "gui", "dump-json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.key = JSON.parse(text).apiKey || "";
                } catch (e) {
                    root.key = "";
                }
                if (root.key)
                    root.pull();
                else
                    root.up = false;
            }
        }
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
