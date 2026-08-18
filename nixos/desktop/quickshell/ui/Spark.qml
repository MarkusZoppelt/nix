import QtQuick
import ".."

Canvas {
    id: root
    property var points: []
    property var stroke
    implicitWidth: 52
    implicitHeight: 16
    onPointsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onStrokeChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        ctx.reset();
        const pts = root.points || [];
        if (pts.length < 2)
            return;
        const w = width;
        const h = height;
        ctx.strokeStyle = root.stroke || Theme.blue;
        ctx.lineWidth = 1.4;
        ctx.lineJoin = "round";
        ctx.lineCap = "round";
        ctx.beginPath();
        for (let i = 0; i < pts.length; i++) {
            const x = i / (pts.length - 1) * w;
            const y = Math.max(1, Math.min(h - 1, h - Number(pts[i] || 0) * (h - 2)));
            if (i === 0)
                ctx.moveTo(x, y);
            else
                ctx.lineTo(x, y);
        }
        ctx.stroke();
    }
}
