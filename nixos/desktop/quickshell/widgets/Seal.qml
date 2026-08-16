import ".."
import "../ui"

Chip {
    id: root
    color: !Trust.locked ? Theme.red : (Trust.firmwareQuirk ? Theme.orange : Theme.green)
    text: Trust.locked ? "󰒃" : "󰒃 !"
    tip: Trust.tip
    onClicked: panel.toggle(root)

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: Trust.locked ? "Sealed" : "Degraded"
            subtitle: Trust.firmware || "this machine"
        }

        Section {
            title: "BOOT"

            StatRow {
                label: "Secure Boot"
                value: Trust.secureBoot ? "enabled" : "off"
            }

            StatRow {
                label: "TPM2"
                value: Trust.tpm ? "yes" : "no"
            }

            StatRow {
                label: "Measured UKI"
                value: Trust.uki ? "yes" : "no"
            }

            StatRow {
                visible: Trust.firmwareQuirk
                label: "Firmware"
                value: "FQ0001"
            }
        }

        Section {
            title: "DISKS"

            StatRow {
                label: "LUKS"
                value: Trust.unlocked + " / " + Trust.luks + " open"
            }
        }
    }
}
