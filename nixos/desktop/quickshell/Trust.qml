pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool secureBoot: false
    property bool tpm: false
    property bool uki: false
    property bool setupMode: false
    property bool firmwareQuirk: false
    property string firmware: ""
    property int luks: 0
    property int unlocked: 0
    readonly property bool locked: secureBoot && tpm && !setupMode
    readonly property string tip: [locked ? "secure boot · tpm" : "trust degraded", firmwareQuirk ? "firmware quirk FQ0001" : "", unlocked + "/" + luks + " luks"].filter(Boolean).join("\n")

    Process {
        running: true
        command: ["sh", "-c", "echo '---BOOT---'; bootctl status; echo '---SBCTL---'; sbctl status; echo '---LSBLK---'; lsblk -J -o NAME,TYPE,FSTYPE"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text;
                root.secureBoot = /Secure Boot:\s+enabled/i.test(t) || /Secure Boot:\s+✓ Enabled/.test(t);
                root.tpm = /TPM2 Support:\s+yes/.test(t);
                root.uki = /Measured UKI:\s+yes/.test(t);
                root.setupMode = /Setup Mode:\s+Enabled/.test(t);
                root.firmwareQuirk = /FQ0001/.test(t);
                const fw = t.match(/Firmware:\s+(.+)/);
                root.firmware = fw ? fw[1].trim() : "";
                try {
                    const json = t.slice(t.indexOf("---LSBLK---") + 11);
                    const disks = JSON.parse(json).blockdevices || [];
                    let luks = 0;
                    let open = 0;
                    const walk = nodes => {
                        for (const n of nodes || []) {
                            if (n.fstype === "crypto_LUKS") {
                                luks++;
                                if ((n.children || []).some(c => c.type === "crypt"))
                                    open++;
                            }
                            walk(n.children);
                        }
                    };
                    walk(disks);
                    root.luks = luks;
                    root.unlocked = open;
                } catch (e) {
                }
            }
        }
    }
}
