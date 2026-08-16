import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import ".."
import "../ui"

Chip {
    id: root
    property string tsState: ""
    property string tsHost: ""
    property string tsDns: ""
    property string tsIp: ""
    property var peers: []
    property var addrs: []
    property real lastRx: 0
    property real lastTx: 0
    property real lastAt: 0
    property string rx: "—"
    property string tx: "—"
    readonly property var up: Networking.devices.values.filter(d => d.connected)
    text: up.some(d => d.type === DeviceType.Wifi) ? "󰤢" : up.some(d => d.type === DeviceType.Wired) ? "󰈀" : "󰤠"
    color: up.length ? Theme.fg : Theme.comment
    tip: [rx + "↓ " + tx + "↑", tsHost, tsIp].filter(Boolean).join(" · ")
    onClicked: {
        net.running = true;
        panel.toggle(root);
    }

    Process {
        id: net
        running: true
        command: ["sh", "-c", "echo TS $(tailscale status --json 2>/dev/null | jq -c '{s:.BackendState,h:.Self.HostName,d:.Self.DNSName,ip:(.Self.TailscaleIPs[0]//\"\"),peers:[.Peer[]|{n:.HostName,on:.Online,os:.OS,ip:(.TailscaleIPs[0]//\"\")}]|sort_by(.n)}'); echo IP $(ip -j -br addr | jq -c '[.[]|select(.ifname!=\"lo\")|{n:.ifname,st:.operstate,ip:([.addr_info[]|select((.local|test(\":\")|not))|.local][0]//\"\")}]')"]
        stdout: StdioCollector {
            onStreamFinished: {
                for (const line of text.trim().split("\n")) {
                    const i = line.indexOf(" ");
                    const k = line.slice(0, i);
                    const raw = line.slice(i + 1);
                    try {
                        const o = JSON.parse(raw);
                        if (k === "TS") {
                            root.tsState = o.s || "";
                            root.tsHost = o.h || "";
                            root.tsDns = (o.d || "").replace(/\.$/, "");
                            root.tsIp = o.ip || "";
                            root.peers = o.peers || [];
                        } else if (k === "IP")
                            root.addrs = o || [];
                    } catch (e) {
                    }
                }
            }
        }
    }

    function rate(bytes) {
        const bps = Math.max(0, bytes) * 8;
        if (bps >= 1e9)
            return (bps / 1e9).toFixed(bps >= 1e10 ? 1 : 2) + " Gbps";
        if (bps >= 1e6)
            return (bps / 1e6).toFixed(bps >= 1e7 ? 1 : 2) + " Mbps";
        if (bps >= 1e3)
            return Math.round(bps / 1e3) + " Kbps";
        return Math.round(bps) + " bps";
    }

    Process {
        id: traffic
        running: true
        command: ["sh", "-c", "awk '$1!~/lo:|tailscale/{rx+=$2;tx+=$10} END{print rx,tx}' /proc/net/dev"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [rx, tx] = text.trim().split(/\s+/).map(Number);
                const now = Date.now();
                if (root.lastAt && now > root.lastAt) {
                    const dt = (now - root.lastAt) / 1000;
                    root.rx = root.rate((rx - root.lastRx) / dt);
                    root.tx = root.rate((tx - root.lastTx) / dt);
                }
                root.lastRx = rx;
                root.lastTx = tx;
                root.lastAt = now;
            }
        }
    }

    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: net.running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: traffic.running = true
    }

    PanelCard {
        id: panel
        paneWidth: 400

        Heading {
            title: root.tsHost || "Network"
            subtitle: [root.tsDns, root.tsState].filter(Boolean).join(" · ")
        }

        Section {
            title: "THROUGHPUT"

            StatRow {
                label: "Down"
                value: root.rx
            }

            StatRow {
                label: "Up"
                value: root.tx
            }
        }

        Section {
            visible: root.tsIp !== ""
            title: "TAILNET"

            StatRow {
                label: "Address"
                value: root.tsIp
            }

            StatRow {
                label: "Online"
                value: root.peers.filter(p => p.on).length + " / " + root.peers.length
            }

            Repeater {
                model: root.peers

                StatRow {
                    required property var modelData
                    label: modelData.n
                    value: (modelData.on ? "up" : "down") + (modelData.os ? " · " + modelData.os : "")
                }
            }
        }

        Section {
            title: "LINKS"

            Repeater {
                model: root.addrs

                StatRow {
                    required property var modelData
                    label: modelData.n
                    value: (modelData.ip || modelData.st || "—")
                }
            }
        }
    }
}
