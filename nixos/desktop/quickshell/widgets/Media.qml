import QtQuick
import ".."
import "../ui"

Chip {
    id: root
    visible: !!Audio.player
    color: Theme.magenta
    maxWidth: 216
    marquee: true
    text: {
        const p = Audio.player;
        return p ? (p.isPlaying ? "󰐊 " : "󰏤 ") + (p.trackTitle || p.identity || "ncspot") : "";
    }
    tip: {
        const p = Audio.player;
        return p ? ((p.trackArtist || "") + (p.trackArtist && p.trackTitle ? " — " : "") + (p.trackTitle || p.identity || "ncspot")) : "";
    }
    onClicked: button => {
        const p = Audio.player;
        if (!p)
            return;
        if (button === Qt.RightButton && p.canGoNext)
            p.next();
        else
            panel.toggle(root);
    }

    Timer {
        interval: 1000
        running: !!Audio.player?.isPlaying
        repeat: true
        onTriggered: Audio.player?.positionChanged()
    }

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: Audio.player?.trackTitle || "Nothing playing"
            subtitle: [Audio.player?.trackArtist, Audio.player?.trackAlbum, Audio.player?.identity].filter(Boolean).join(" · ")
        }

        Item {
            visible: !!(Audio.player?.trackArtUrl)
            width: parent.width
            implicitHeight: 180

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: Audio.player?.trackArtUrl || ""
                asynchronous: true
                cache: false
            }

            Eq {
                values: Audio.eq
                anchors.fill: parent
                anchors.margins: 8
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: 1
                border.color: Theme.black
                radius: Theme.radius
            }
        }

        Column {
            visible: !!(Audio.player?.length)
            width: parent.width
            spacing: 6

            Meter {
                width: parent.width
                value: Audio.player && Audio.player.length > 0 ? Audio.player.position / Audio.player.length : 0
            }

            Item {
                width: parent.width
                implicitHeight: 14

                Text {
                    text: {
                        const p = Audio.player;
                        if (!p)
                            return "";
                        const s = Math.floor(p.position);
                        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
                    }
                    color: Theme.comment
                    font.family: Theme.font
                    font.pixelSize: 12
                }

                Text {
                    anchors.right: parent.right
                    text: {
                        const p = Audio.player;
                        if (!p)
                            return "";
                        const s = Math.floor(p.length);
                        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
                    }
                    color: Theme.comment
                    font.family: Theme.font
                    font.pixelSize: 12
                }
            }
        }

        Row {
            width: parent.width
            spacing: 8

            Repeater {
                model: [{
                        id: "prev",
                        name: "󰒮"
                    }, {
                        id: "play",
                        name: Audio.player?.isPlaying ? "󰏤" : "󰐊"
                    }, {
                        id: "next",
                        name: "󰒭"
                    }]

                Rectangle {
                    required property var modelData
                    width: (parent.width - 16) / 3
                    implicitHeight: 36
                    radius: 6
                    color: hover.containsMouse ? Qt.alpha(Theme.magenta, 0.25) : Theme.bgHighlight
                    border.width: 1
                    border.color: Theme.black

                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: Theme.fg
                        font.family: Theme.font
                        font.pixelSize: 18
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            const p = Audio.player;
                            if (!p)
                                return;
                            if (modelData.id === "prev" && p.canGoPrevious)
                                p.previous();
                            else if (modelData.id === "next" && p.canGoNext)
                                p.next();
                            else if (modelData.id === "play" && p.canTogglePlaying)
                                p.togglePlaying();
                        }
                    }
                }
            }
        }
    }
}
