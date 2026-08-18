import QtQuick
import ".."

Item {
    id: root
    property var values: []
    property bool spectrum: true
    property var stroke
    readonly property int bars: values ? values.length : 0
    readonly property var ramp: [Theme.blue, Theme.cyan, Theme.green1, Theme.yellow, Theme.orange, Theme.magenta, Theme.red]
    implicitWidth: Math.max(bars * 6, 1)
    implicitHeight: 18
    visible: bars > 0
    clip: true

    function colorAt(i, a) {
        if (!spectrum)
            return Qt.alpha(stroke || Theme.magenta, a);
        const t = bars < 2 ? 0 : i / (bars - 1) * (ramp.length - 1);
        const s = Math.min(Math.floor(t), ramp.length - 2);
        const m = t - s;
        return Qt.rgba(ramp[s].r * (1 - m) + ramp[s + 1].r * m, ramp[s].g * (1 - m) + ramp[s + 1].g * m, ramp[s].b * (1 - m) + ramp[s + 1].b * m, a);
    }

    Repeater {
        model: root.bars

        Rectangle {
            required property int index
            readonly property real gap: root.width / Math.max(root.bars, 1)
            readonly property real level: Math.pow(Math.max(0, Math.min(1, Number(root.values[index] || 0) / 100)), 0.65)
            width: Math.max(2, Math.min(5, gap - 2))
            radius: 1
            color: root.colorAt(index, 0.12 + level * 0.28)
            anchors.bottom: parent.bottom
            x: index * gap + Math.max(0, (gap - width) / 2)
            height: Math.max(1, Math.round(level * root.height))
        }
    }
}
