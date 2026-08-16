import QtQuick
import Quickshell.Services.UPower
import ".."
import "../ui"

Chip {
    id: root
    visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
    color: UPower.displayDevice.percentage <= 0.15 ? Theme.red : Theme.green
    text: {
        const d = UPower.displayDevice;
        const n = Math.round(d.percentage * 100);
        return (d.state === UPowerDeviceState.Charging ? "󰂄 " : "󰁹 ") + n + "%";
    }
    tip: UPower.displayDevice.model || "battery"
    onClicked: panel.toggle(root)

    function eta(sec) {
        if (!(sec > 0))
            return "";
        const m = Math.round(sec / 60);
        if (m < 60)
            return m + "m";
        return Math.floor(m / 60) + "h " + (m % 60) + "m";
    }

    PanelCard {
        id: panel
        paneWidth: 320

        Heading {
            title: "Battery"
            subtitle: UPower.displayDevice.model || ""
        }

        StatRow {
            label: UPower.displayDevice.state === UPowerDeviceState.Charging ? "Charging" : "Charge"
            value: Math.round(UPower.displayDevice.percentage * 100) + "%"
            ratio: UPower.displayDevice.percentage
        }

        Text {
            visible: eta(UPower.displayDevice.timeToEmpty || UPower.displayDevice.timeToFull) !== ""
            text: (UPower.displayDevice.state === UPowerDeviceState.Charging ? "full in " : "empty in ") + eta(UPower.displayDevice.timeToEmpty || UPower.displayDevice.timeToFull)
            color: Theme.comment
            font.family: Theme.font
            font.pixelSize: 13
        }

        StatRow {
            visible: UPower.displayDevice.healthSupported
            label: "Health"
            value: Math.round(UPower.displayDevice.healthPercentage) + "%"
            ratio: UPower.displayDevice.healthPercentage / 100
        }
    }
}
