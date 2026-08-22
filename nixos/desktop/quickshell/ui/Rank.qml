import QtQuick
import ".."

Well {
    id: root
    property string title: ""
    property var rows: []
    property int slots: 0

    Section {
        title: root.title
        ink: root.ink
        spacing: 6

        Repeater {
            model: root.slots > 0 ? root.slots : root.rows

            StatRow {
                required property var modelData
                required property int index
                readonly property var row: root.slots > 0 ? (root.rows[index] || {}) : modelData
                label: row.name || "—"
                value: row.value || "—"
                ink: root.ink
            }
        }
    }
}
