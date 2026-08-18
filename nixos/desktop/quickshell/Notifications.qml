import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

Scope {
    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            if (n.appName === "Spotify")
                return;
            n.tracked = true;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: "transparent"
            aboveWindows: true
            focusable: false
            exclusionMode: ExclusionMode.Ignore
            implicitWidth: 400
            implicitHeight: Math.max(col.implicitHeight, 1)
            WlrLayershell.namespace: "notifications"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            anchors {
                top: true
                right: true
            }
            margins {
                top: 12
                right: 12
            }

            Column {
                id: col
                width: 400
                spacing: Theme.pad

                Repeater {
                    model: server.trackedNotifications

                    Rectangle {
                        required property var modelData
                        width: parent.width
                        implicitHeight: body.implicitHeight + 40
                        color: Qt.alpha(Theme.bg, 0.93)
                        radius: Theme.radius
                        border.width: 1
                        border.color: Theme.blue

                        Column {
                            id: body
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 6

                            Text {
                                width: parent.width
                                text: modelData.summary
                                color: Theme.fg
                                font.family: Theme.font
                                font.pixelSize: 16
                                wrapMode: Text.Wrap
                            }

                            Text {
                                visible: modelData.body.length > 0
                                width: parent.width
                                text: modelData.body
                                color: Theme.fgDark
                                font.family: Theme.font
                                font.pixelSize: 13
                                wrapMode: Text.Wrap
                                textFormat: Text.PlainText
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: modelData.dismiss()
                        }

                        Timer {
                            interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : 5000
                            running: true
                            onTriggered: modelData.expire()
                        }
                    }
                }
            }
        }
    }
}
