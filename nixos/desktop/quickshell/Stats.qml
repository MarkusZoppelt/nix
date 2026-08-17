pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root
    property real cpuN: 0
    property real memN: 0
    property real swapN: 0
    property string cpuPct: "—"
    property string memUsed: "—"
    property string memTotal: "—"
    property string swapUsed: "—"
    property string swapTotal: "—"
    property string load: "—"
    property string uptime: "—"
    property string host: ""
    property string kernel: ""
    property string cores: ""
    property string gpu: ""
    property real gpuN: 0
    property var disks: []
    property var cpuHist: []
    property var memHist: []
    property real lastIdle: 0
    property real lastTotal: 0
    readonly property string profileName: PowerProfiles.profile === PowerProfile.PowerSaver ? "Power Saver" : PowerProfiles.profile === PowerProfile.Performance ? "Performance" : "Balanced"
    readonly property string tip: [host, "CPU " + cpuPct + (cores ? " · " + cores + " cores" : ""), "load " + load, "RAM " + memUsed + " / " + memTotal, "swap " + swapUsed + " / " + swapTotal, gpu ? "GPU " + gpu : "", "up " + uptime, kernel].filter(s => s).join("\n")

    function bytes(n) {
        const v = Number(n) || 0;
        if (v >= 1099511627776)
            return (v / 1099511627776).toFixed(1) + "T";
        if (v >= 1073741824)
            return (v / 1073741824).toFixed(1) + "G";
        if (v >= 1048576)
            return (v / 1048576).toFixed(1) + "M";
        return Math.round(v / 1024) + "K";
    }

    function push(hist, n) {
        return hist.concat([Math.max(0, Math.min(1, Number(n) || 0))]).slice(-36);
    }

    function setProfile(name) {
        const map = {
            "Power Saver": PowerProfile.PowerSaver,
            Balanced: PowerProfile.Balanced,
            Performance: PowerProfile.Performance
        };
        if (name === "Performance" && !PowerProfiles.hasPerformanceProfile)
            return;
        PowerProfiles.profile = map[name];
    }

    Process {
        id: proc
        running: true
        command: ["sh", "-c", "grep 'cpu ' /proc/stat; awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} /SwapTotal/{st=$2} /SwapFree/{sf=$2} END{printf \"MEM %.1f %.1f %.1f %.1f\\n\", (t-a)/1048576, t/1048576, (st-sf)/1048576, st/1048576}' /proc/meminfo; echo LOAD $(cut -d' ' -f1-3 /proc/loadavg); awk '{d=int($1/86400);h=int(($1%86400)/3600);m=int(($1%3600)/60); printf \"UP \"; if(d) print d\"d \"h\"h\"; else if(h) print h\"h \"m\"m\"; else print m\"m\"}' /proc/uptime; echo HOST $(hostname); echo KERNEL $(uname -r); echo CORES $(nproc); echo GPU $(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const cpu = (lines[0] || "").trim().split(/\s+/).slice(1).map(Number);
                if (cpu.length) {
                    const idle = (cpu[3] || 0) + (cpu[4] || 0);
                    const total = cpu.slice(0, 8).reduce((a, b) => a + (Number(b) || 0), 0);
                    const di = idle - root.lastIdle;
                    const dt = total - root.lastTotal;
                    if (root.lastTotal > 0 && dt > 0) {
                        root.cpuN = Math.max(0, Math.min(1, 1 - di / dt));
                        root.cpuPct = Math.round(root.cpuN * 100) + "%";
                    }
                    root.lastIdle = idle;
                    root.lastTotal = total;
                }
                for (const line of lines.slice(1)) {
                    const [k, ...rest] = line.split(/\s+/);
                    const v = rest.join(" ");
                    if (k === "MEM") {
                        root.memUsed = rest[0] + "G";
                        root.memTotal = rest[1] + "G";
                        root.swapUsed = rest[2] + "G";
                        root.swapTotal = rest[3] + "G";
                        root.memN = Number(rest[1]) > 0 ? Number(rest[0]) / Number(rest[1]) : 0;
                        root.swapN = Number(rest[3]) > 0 ? Number(rest[2]) / Number(rest[3]) : 0;
                    } else if (k === "LOAD")
                        root.load = v;
                    else if (k === "UP")
                        root.uptime = v;
                    else if (k === "HOST")
                        root.host = v;
                    else if (k === "KERNEL")
                        root.kernel = v;
                    else if (k === "CORES")
                        root.cores = v;
                    else if (k === "GPU" && v) {
                        const p = v.split(",");
                        if (p.length >= 4) {
                            root.gpuN = Number(p[0]) / 100;
                            root.gpu = p[0] + "% · " + p[1] + "/" + p[2] + " MiB · " + p[3] + "°C";
                        }
                    }
                }
                root.cpuHist = root.push(root.cpuHist, root.cpuN);
                root.memHist = root.push(root.memHist, root.memN);
            }
        }
    }

    Process {
        id: duf
        running: true
        command: ["duf", "--json", "--only", "local"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.disks = JSON.parse(text).filter(d => d.device_type === "local" && d.total > 0).map(d => ({
                                mount: d.mount_point,
                                device: d.device,
                                fstype: d.fs_type,
                                used: d.used,
                                free: d.free,
                                total: d.total,
                                usage: d.used / d.total
                            })).sort((a, b) => a.mount.localeCompare(b.mount));
                } catch (e) {
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: proc.running = true
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: duf.running = true
    }
}
