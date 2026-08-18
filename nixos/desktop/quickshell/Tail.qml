pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "ui"

Singleton {
    id: root
    property string state: ""
    property string host: ""
    property string dns: ""
    property string ip: ""
    property var peers: []
    property string exit: ""
    readonly property bool up: state === "Running"
    readonly property int live: peers.filter(p => p.on).length
    readonly property var exits: {
        const flagged = peers.filter(p => p.opt || p.exit);
        return flagged.length ? flagged : peers.filter(p => p.on);
    }
    readonly property var exitNode: exits.find(p => p.exit || p.ip === exit) || null

    function glyph(os) {
        const s = (os || "").toLowerCase();
        return s === "linux" ? "󰌽" : s === "macos" || s === "ios" ? "󰀵" : s === "windows" ? "󰍲" : s === "android" ? "󰀲" : "󰟀";
    }

    function refresh() {
        status.running = true;
    }

    function toggle() {
        console.warn("Tail.toggle", up ? "down" : "up");
        Quickshell.execDetached(["tailscale", up ? "down" : "up"]);
        Qt.callLater(refresh);
    }

    function copy(value) {
        if (value)
            Quickshell.execDetached(["wl-copy", value]);
    }

    function setExit(ip) {
        Quickshell.execDetached(["tailscale", "set", "--exit-node=" + (ip || "")]);
        Qt.callLater(refresh);
    }

    function toggleExit() {
        setExit(exit ? "" : (exits[0]?.ip || ""));
    }

    Poll {
        id: status
        interval: 8000
        command: ["sh", "-c", "tailscale status --json 2>/dev/null | jq -c '{s:.BackendState,h:.Self.HostName,d:.Self.DNSName,ip:(.Self.TailscaleIPs[0]//\"\"),exit:(.ExitNodeStatus.TailscaleIPs[0]//\"\"),peers:[.Peer[]|{n:.HostName,on:.Online,os:.OS,ip:(.TailscaleIPs[0]//\"\"),dns:.DNSName,opt:.ExitNodeOption,exit:.ExitNode}]|sort_by(.n)}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const o = JSON.parse(text.trim());
                    root.state = o.s || "";
                    root.host = o.h || "";
                    root.dns = (o.d || "").replace(/\.$/, "");
                    root.ip = o.ip || "";
                    root.exit = o.exit || "";
                    root.peers = o.peers || [];
                } catch (e) {
                    root.state = "";
                    root.host = "";
                    root.dns = "";
                    root.ip = "";
                    root.exit = "";
                    root.peers = [];
                }
            }
        }
    }
}
