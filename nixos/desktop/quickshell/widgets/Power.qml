import ".."
import "../ui"

Chip {
    id: root
    color: Theme.fgDark
    text: "󰐥"
    onClicked: menu.open(root)

    Menu {
        id: menu
        items: [
            {
                id: "lock",
                text: "Lock"
            },
            {
                id: "sleep",
                text: "Sleep"
            },
            {
                separator: true
            },
            {
                id: "relaunch",
                text: "Relaunch"
            },
            {
                id: "restart",
                text: "Restart"
            },
            {
                id: "shutdown",
                text: "Shutdown",
                danger: true
            }
        ]
        onPicked: item => Session.run(item.id)
    }
}
