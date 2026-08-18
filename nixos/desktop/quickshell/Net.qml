pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import "ui"

Singleton {
    id: root
    property real lastRx: 0
    property real lastTx: 0
    property real lastAt: 0
    property string rx: "—"
    property string tx: "—"
    property var addrs: []

    readonly property var wifi: pick(DeviceType.Wifi)
    readonly property var wired: pick(DeviceType.Wired)
    readonly property var active: wired?.connected ? wired : (wifi?.connected ? wifi : wired || wifi)
    readonly property var ssid: (wifi?.networks?.values || []).find(n => n.connected)?.name || ""
    readonly property real signal: (wifi?.networks?.values || []).find(n => n.connected)?.signalStrength || 0
    readonly property var nets: (wifi?.networks?.values || []).slice().sort((a, b) => (b.connected - a.connected) || (b.known - a.known) || ((b.signalStrength || 0) - (a.signalStrength || 0)))

    function pick(type) {
        const all = Networking.devices.values.filter(d => d.type === type);
        return all.find(d => d.connected) || all[0] || null;
    }

    function bars(n) {
        const s = Math.round((n || 0) * 100);
        return s >= 80 ? "󰤨" : s >= 60 ? "󰤥" : s >= 40 ? "󰤢" : s >= 20 ? "󰤟" : "󰤯";
    }

    function icon() {
        if (wired?.connected)
            return "󰈀";
        if (wifi?.connected)
            return bars(signal);
        return Networking.wifiEnabled ? "󰤮" : "󰤭";
    }

    function locked(n) {
        const s = n?.security;
        return s !== WifiSecurityType.Open && s !== WifiSecurityType.Owe;
    }

    function scan(on) {
        if (wifi)
            wifi.scannerEnabled = on;
    }

    Poll {
        interval: 8000
        command: ["sh", "-c", "ip -j -br addr | jq -c '[.[]|select(.ifname!=\"lo\" and (.ifname|startswith(\"tailscale\")|not))|{n:.ifname,st:.operstate,ip:([.addr_info[]|select((.local|test(\":\")|not))|.local][0]//\"\")}]'"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.addrs = JSON.parse(text.trim()) || [];
                } catch (e) {
                }
            }
        }
    }

    Poll {
        interval: 2000
        command: ["sh", "-c", "awk '$1!~/lo:|tailscale/{rx+=$2;tx+=$10} END{print rx,tx}' /proc/net/dev"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [rx, tx] = text.trim().split(/\s+/).map(Number);
                const now = Date.now();
                if (root.lastAt && now > root.lastAt) {
                    const dt = (now - root.lastAt) / 1000;
                    root.rx = Fmt.rate((rx - root.lastRx) / dt);
                    root.tx = Fmt.rate((tx - root.lastTx) / dt);
                }
                root.lastRx = rx;
                root.lastTx = tx;
                root.lastAt = now;
            }
        }
    }
}
