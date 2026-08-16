import QtQuick
import ".."
import "../ui"

Chip {
    id: root
    color: Theme.cyan
    text: {
        const audio = Audio.sink?.audio;
        if (!audio || audio.muted)
            return "󰸈";
        const n = Math.round(audio.volume * 100);
        return (n > 66 ? "󰕾 " : n > 33 ? "󰖀 " : "󰕿 ") + n + "%";
    }
    tip: Audio.sink?.audio?.muted ? "muted · scroll to change" : Audio.label(Audio.sink)
    onClicked: button => {
        if (button === Qt.RightButton && Audio.sink?.audio)
            Audio.sink.audio.muted = !Audio.sink.audio.muted;
        else
            panel.toggle(root);
    }
    onWheeled: dy => {
        if (!Audio.sink?.audio)
            return;
        Audio.sink.audio.volume = Math.max(0, Math.min(1, Audio.sink.audio.volume + (dy > 0 ? 0.05 : -0.05)));
        Osd.show(Audio.sink.audio.muted ? 0 : Audio.sink.audio.volume, Audio.sink.audio.muted ? "󰸈" : "󰕾", Math.round(Audio.sink.audio.volume * 100) + "%");
    }

    PanelCard {
        id: panel
        paneWidth: 380

        Heading {
            title: "Audio"
            subtitle: Audio.label(Audio.sink)
        }

        Section {
            title: "OUTPUT"

            StatRow {
                label: Audio.sink?.audio?.muted ? "Muted" : "Volume"
                value: Audio.sink?.audio ? Math.round(Audio.sink.audio.volume * 100) + "%" : "—"
                ratio: Audio.sink?.audio && !Audio.sink.audio.muted ? Audio.sink.audio.volume : 0
            }

            Repeater {
                model: Audio.sinks

                Rectangle {
                    required property var modelData
                    width: parent ? parent.width : 352
                    implicitHeight: 32
                    radius: 6
                    color: modelData === Audio.sink ? Qt.alpha(Theme.cyan, 0.22) : (hover.containsMouse ? Theme.bgHighlight : "transparent")
                    border.width: 1
                    border.color: modelData === Audio.sink ? Theme.cyan : Theme.black

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: Audio.label(modelData)
                        color: Theme.fg
                        font.family: Theme.font
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Audio.setSink(modelData)
                    }
                }
            }
        }

        Section {
            visible: Audio.sources.length > 0
            title: "INPUT"

            StatRow {
                visible: !!Audio.source?.audio
                label: Audio.source?.audio?.muted ? "Muted" : "Mic"
                value: Audio.source?.audio ? Math.round(Audio.source.audio.volume * 100) + "%" : "—"
                ratio: Audio.source?.audio && !Audio.source.audio.muted ? Audio.source.audio.volume : 0
            }

            Repeater {
                model: Audio.sources

                Rectangle {
                    required property var modelData
                    width: parent ? parent.width : 352
                    implicitHeight: 32
                    radius: 6
                    color: modelData === Audio.source ? Qt.alpha(Theme.cyan, 0.22) : (hover.containsMouse ? Theme.bgHighlight : "transparent")
                    border.width: 1
                    border.color: modelData === Audio.source ? Theme.cyan : Theme.black

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: Audio.label(modelData)
                        color: Theme.fg
                        font.family: Theme.font
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Audio.setSource(modelData)
                    }
                }
            }
        }

        Section {
            visible: Audio.streams.length > 0
            title: "APPS"

            Repeater {
                model: Audio.streams

                StatRow {
                    required property var modelData
                    label: Audio.label(modelData)
                    value: modelData.audio?.muted ? "mute" : Math.round((modelData.audio?.volume || 0) * 100) + "%"
                    ratio: modelData.audio && !modelData.audio.muted ? modelData.audio.volume : 0
                }
            }
        }
    }
}
