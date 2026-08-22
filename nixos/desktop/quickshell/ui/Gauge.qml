import QtQuick
import ".."

Item {
    id: root
    property real value: 0
    property string label: ""
    property string readout: ""
    property string detail: ""
    property var ink
    implicitWidth: 120
    implicitHeight: 132

    Canvas {
        id: dial
        anchors.horizontalCenter: parent.horizontalCenter
        width: 76
        height: 76
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const cx = width / 2;
            const cy = height / 2 + 4;
            const r = 28;
            const start = Math.PI * 0.75;
            const span = Math.PI * 1.5;
            const n = Math.max(0, Math.min(1, root.value));
            const stroke = root.ink || Theme.green;
            ctx.lineWidth = 6;
            ctx.lineCap = "round";
            ctx.strokeStyle = Qt.alpha(stroke, 0.22);
            ctx.beginPath();
            ctx.arc(cx, cy, r, start, start + span);
            ctx.stroke();
            if (n > 0) {
                ctx.strokeStyle = n >= 0.9 ? Theme.red : stroke;
                ctx.beginPath();
                ctx.arc(cx, cy, r, start, start + span * n);
                ctx.stroke();
            }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Connections {
            target: root
            function onValueChanged() {
                dial.requestPaint();
            }
            function onInkChanged() {
                dial.requestPaint();
            }
        }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 4
            text: root.readout || (Math.round(root.value * 100) + "%")
            color: root.ink || Theme.green
            font.family: Theme.font
            font.pixelSize: 14
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 78
        text: root.label
        color: Theme.comment
        font.family: Theme.font
        font.pixelSize: 11
    }

    Text {
        visible: root.detail !== ""
        anchors.horizontalCenter: parent.horizontalCenter
        y: 94
        text: root.detail
        color: Theme.fgDark
        font.family: Theme.font
        font.pixelSize: 11
    }
}
