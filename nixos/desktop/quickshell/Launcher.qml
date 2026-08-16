pragma Singleton
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Singleton {
    id: root
    property bool open: false
    property bool powerOnly: false
    property int selected: 0
    property string query: ""

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

    readonly property var results: {
        const q = query.trim().toLowerCase();
        const hit = e => !q || [e.name, e.hint, ...(e.keywords || [])].join(" ").toLowerCase().includes(q);
        if (powerOnly)
            return powerItems.filter(hit);
        const apps = DesktopEntries.applications.values.filter(app => !app.noDisplay).map(app => ({
                    name: app.name,
                    hint: app.genericName || app.comment || "",
                    keywords: app.keywords,
                    icon: app.icon,
                    run: () => app.execute()
                })).filter(hit);
        return q ? apps.concat(powerItems.filter(hit)) : apps;
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

            HyprlandFocusGrab {
                windows: [win]
                active: root.open
                onCleared: root.close()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 160
                width: 640
                implicitHeight: 56 + (root.results.length ? Math.min(root.results.length, 8) * 48 + 12 : 0)
                color: Theme.bg
                radius: 14
                border.width: 1
                border.color: Theme.black

                MouseArea {
                    anchors.fill: parent
                }

                TextField {
                    id: field
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 56
                    text: root.query
                    placeholderText: root.powerOnly ? "Power" : "Search"
                    color: Theme.fg
                    placeholderTextColor: Theme.comment
                    font.pixelSize: 20
                    leftPadding: 20
                    rightPadding: 20
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

                Rectangle {
                    visible: root.results.length > 0
                    anchors.top: field.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Theme.black
                }

                ListView {
                    visible: root.results.length > 0
                    anchors.top: field.bottom
                    anchors.topMargin: 6
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 6
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    currentIndex: root.selected
                    model: root.results

                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        width: ListView.view.width
                        height: 48
                        radius: 10
                        color: index === root.selected ? Theme.bgHighlight : "transparent"

                        Image {
                            id: icon
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            width: 28
                            height: 28
                            sourceSize.width: 28
                            sourceSize.height: 28
                            fillMode: Image.PreserveAspectFit
                            source: modelData.icon ? Quickshell.iconPath(modelData.icon, true) : ""
                        }

                        Text {
                            anchors.left: icon.right
                            anchors.right: hint.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            elide: Text.ElideRight
                            text: modelData.name
                            color: Theme.fg
                            font.pixelSize: 15
                        }

                        Text {
                            id: hint
                            anchors.right: parent.right
                            anchors.rightMargin: 14
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.hint
                            color: Theme.comment
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            width: Math.min(implicitWidth, 180)
                            horizontalAlignment: Text.AlignRight
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selected = index
                            onClicked: {
                                root.selected = index;
                                root.activate();
                            }
                        }
                    }
                }
            }
        }
    }
}
