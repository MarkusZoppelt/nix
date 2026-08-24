import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: root
    property var stroke
    width: 15
    height: 15
    implicitWidth: 15
    implicitHeight: 15

    readonly property real cx: 7.5
    readonly property real cy: 8
    readonly property var nodes: [
        {
            x: 11.2,
            y: 3.6
        },
        {
            x: 11.4,
            y: 11.6
        },
        {
            x: 2.6,
            y: 8.8
        }
    ]

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: 1.3
        border.color: root.stroke || Theme.fg
    }

    Shape {
        anchors.fill: parent

        ShapePath {
            strokeWidth: 1.3
            strokeColor: root.stroke || Theme.fg
            fillColor: "transparent"
            startX: root.cx
            startY: root.cy
            PathLine {
                x: root.nodes[0].x
                y: root.nodes[0].y
            }
        }

        ShapePath {
            strokeWidth: 1.3
            strokeColor: root.stroke || Theme.fg
            fillColor: "transparent"
            startX: root.cx
            startY: root.cy
            PathLine {
                x: root.nodes[1].x
                y: root.nodes[1].y
            }
        }

        ShapePath {
            strokeWidth: 1.3
            strokeColor: root.stroke || Theme.fg
            fillColor: "transparent"
            startX: root.cx
            startY: root.cy
            PathLine {
                x: root.nodes[2].x
                y: root.nodes[2].y
            }
        }
    }

    Repeater {
        model: [{
                x: root.cx,
                y: root.cy,
                r: 2
            }].concat(root.nodes.map(n => ({
                        x: n.x,
                        y: n.y,
                        r: 1.45
                    })))

        Rectangle {
            required property var modelData
            width: modelData.r * 2
            height: modelData.r * 2
            radius: modelData.r
            x: modelData.x - modelData.r
            y: modelData.y - modelData.r
            color: root.stroke || Theme.fg
        }
    }
}
