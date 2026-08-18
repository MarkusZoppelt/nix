pragma Singleton
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "ui"

Singleton {
    id: root
    property bool open: false
    property bool powerOnly: false
    property int selected: 0
    property string query: ""
    property real dragX: -1
    property real dragY: -1

    readonly property var pinned: ["ghostty", "chromium", "1password"]
    readonly property var powerItems: [
        {
            name: "Lock",
            hint: "hyprlock",
            run: () => Quickshell.execDetached(["hyprlock"])
        },
        {
            name: "Relaunch",
            hint: "exit Hyprland",
            run: () => Hyprland.dispatch("exit")
        },
        {
            name: "Sleep",
            hint: "suspend",
            run: () => Quickshell.execDetached(["systemctl", "suspend"])
        },
        {
            name: "Restart",
            hint: "reboot",
            run: () => Quickshell.execDetached(["systemctl", "reboot"])
        },
        {
            name: "Shutdown",
            hint: "poweroff",
            run: () => Quickshell.execDetached(["systemctl", "poweroff"])
        }
    ]

    function pin(name) {
        const i = pinned.indexOf((name || "").toLowerCase());
        return i < 0 ? pinned.length : i;
    }

    function hit(e, q) {
        return !q || [e.name, e.hint, ...(e.keywords || [])].join(" ").toLowerCase().includes(q);
    }

    function score(e, q) {
        const name = (e.name || "").toLowerCase();
        return name.startsWith(q) ? 0 : name.includes(q) ? 1 : 2;
    }

    function rank(a, b, q) {
        return (q ? score(a, q) - score(b, q) : 0) || pin(a.name) - pin(b.name) || a.name.localeCompare(b.name);
    }

    readonly property var results: {
        const q = query.trim().toLowerCase();
        if (powerOnly)
            return q ? powerItems.filter(e => hit(e, q)).sort((a, b) => rank(a, b, q)) : powerItems;
        const apps = DesktopEntries.applications.values.filter(app => !app.noDisplay).map(app => ({
                    name: app.name,
                    hint: app.genericName || app.comment || "",
                    keywords: app.keywords,
                    icon: app.icon,
                    run: () => {
                        const cmd = app.runInTerminal ? ["ghostty", "+new-window", "-e"].concat(app.command) : app.command;
                        Quickshell.execDetached({
                            command: cmd,
                            workingDirectory: app.workingDirectory
                        });
                    }
                }));
        return (q ? apps.concat(powerItems) : apps).filter(e => hit(e, q)).sort((a, b) => rank(a, b, q));
    }

    function toggle() {
        if (open && !powerOnly)
            return close();
        powerOnly = false;
        open = true;
        selected = 0;
        query = "";
    }

    function openPower() {
        powerOnly = true;
        open = true;
        selected = 0;
        query = "";
    }

    function close() {
        open = false;
        powerOnly = false;
        selected = 0;
        query = "";
    }

    function activate() {
        results[selected]?.run();
        close();
    }

    LazyLoader {
        active: root.open

        PanelWindow {
            id: win
            visible: root.open
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            focusable: true
            WlrLayershell.namespace: "launcher"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            readonly property var accent: root.powerOnly ? Theme.orange : Theme.cyan
            readonly property string ghost: {
                const q = root.query;
                const n = root.results[root.selected]?.name || "";
                return q && n.toLowerCase().startsWith(q.toLowerCase()) ? n.slice(q.length) : "";
            }

            HyprlandFocusGrab {
                windows: [win]
                active: root.open
                onCleared: root.close()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }

            Hud {
                id: hud
                accent: win.accent
                dragX: root.dragX
                dragY: root.dragY
                implicitHeight: 88 + (root.results.length ? Math.min(root.results.length, 8) * 58 + 52 : 18)
                onDragged: (x, y) => {
                    root.dragX = x;
                    root.dragY = y;
                }

                Item {
                    id: header
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 76

                    Text {
                        id: prompt
                        anchors.left: parent.left
                        anchors.leftMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.powerOnly ? "⏻" : "❯"
                        color: win.accent
                        font.family: Theme.font
                        font.pixelSize: 26
                    }

                    Text {
                        anchors.left: field.left
                        anchors.right: count.left
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 4
                        text: field.text + win.ghost
                        color: Qt.alpha(Theme.fg, 0.22)
                        font.family: Theme.font
                        font.pixelSize: 24
                        elide: Text.ElideRight
                    }

                    TextField {
                        id: field
                        anchors.left: prompt.right
                        anchors.right: count.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
                        anchors.rightMargin: 12
                        height: 48
                        text: root.query
                        placeholderText: root.powerOnly ? "power" : "launch"
                        color: Theme.fg
                        placeholderTextColor: Theme.comment
                        font.family: Theme.font
                        font.pixelSize: 24
                        leftPadding: 4
                        rightPadding: 8
                        background: Item {
                        }
                        onTextChanged: {
                            root.query = text;
                            root.selected = 0;
                        }
                        Keys.onEscapePressed: root.close()
                        Keys.onDownPressed: root.selected = Math.min(root.selected + 1, Math.max(root.results.length - 1, 0))
                        Keys.onUpPressed: root.selected = Math.max(root.selected - 1, 0)
                        Keys.onReturnPressed: root.activate()
                        Component.onCompleted: forceActiveFocus()
                    }

                    Text {
                        id: count
                        anchors.right: parent.right
                        anchors.rightMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        text: String(root.results.length).padStart(2, "0")
                        color: win.accent
                        font.family: Theme.font
                        font.pixelSize: 14
                    }
                }

                Rectangle {
                    id: rule
                    anchors.top: header.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    height: 1
                    color: Theme.black
                }

                ListView {
                    visible: root.results.length > 0
                    anchors.top: rule.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: footer.top
                    anchors.topMargin: 7
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    currentIndex: root.selected
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: height
                    highlightRangeMode: ListView.ApplyRange
                    model: root.results

                    highlight: Rectangle {
                        radius: 14
                        color: Qt.alpha(win.accent, 0.1)
                        border.width: 1
                        border.color: Qt.alpha(win.accent, 0.55)

                        Rectangle {
                            width: 3
                            height: parent.height - 16
                            radius: 2
                            anchors.left: parent.left
                            anchors.leftMargin: 6
                            anchors.verticalCenter: parent.verticalCenter
                            color: win.accent
                        }
                    }

                    delegate: LaunchRow {
                        active: index === root.selected
                        pinned: !root.query && root.pin(modelData.name) < root.pinned.length
                        accent: win.accent
                        onHovered: root.selected = index
                        onActivated: {
                            root.selected = index;
                            root.activate();
                        }
                    }
                }

                Item {
                    id: footer
                    visible: root.results.length > 0
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 40

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.powerOnly ? "power session" : (root.query ? "matched" : "favorites first")
                        color: Theme.comment
                        font.family: Theme.font
                        font.pixelSize: 11
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        text: "↑↓ select   ↵ open   esc"
                        color: Theme.dark5
                        font.family: Theme.font
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
