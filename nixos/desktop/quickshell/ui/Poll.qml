import QtQuick
import Quickshell.Io

Item {
    id: root
    property int interval: 2000
    property bool active: true
    property alias running: proc.running
    property alias command: proc.command
    property alias stdout: proc.stdout

    Process {
        id: proc
        running: false
    }

    Timer {
        interval: root.interval
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!proc.running)
            proc.running = true
    }
}
