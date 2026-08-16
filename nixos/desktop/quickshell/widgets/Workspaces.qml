import QtQuick
import Quickshell
import Quickshell.Hyprland
import ".."
import "../ui"

Row {
    spacing: 4

    Repeater {
        model: ScriptModel {
            values: Hyprland.workspaces.values.filter(ws => ws.id > 0)
        }

        Chip {
            required property var modelData
            text: modelData.name + " " + (modelData.focused ? "●" : "○")
            color: modelData.urgent ? Theme.orange : (modelData.focused ? Theme.blue : Theme.fgDark)
            tip: {
                const titles = modelData.toplevels.values.map(t => t.title).filter(Boolean);
                return titles.length ? titles.join("\n") : "workspace " + modelData.name;
            }
            onClicked: modelData.activate()
        }
    }

}
