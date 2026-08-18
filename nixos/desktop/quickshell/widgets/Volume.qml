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
            }

            Fader {
                visible: !!Audio.sink?.audio
                value: Audio.sink?.audio?.volume || 0
                muted: !!Audio.sink?.audio?.muted
                onMoved: n => {
                    if (Audio.sink?.audio)
                        Audio.sink.audio.volume = n;
                }
            }

            Repeater {
                model: Audio.sinks

                Choice {
                    required property var modelData
                    title: Audio.label(modelData)
                    current: modelData === Audio.sink
                    accent: Theme.cyan
                    onClicked: Audio.setSink(modelData)
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
            }

            Fader {
                visible: !!Audio.source?.audio
                value: Audio.source?.audio?.volume || 0
                muted: !!Audio.source?.audio?.muted
                onMoved: n => {
                    if (Audio.source?.audio)
                        Audio.source.audio.volume = n;
                }
            }

            Repeater {
                model: Audio.sources

                Choice {
                    required property var modelData
                    title: Audio.label(modelData)
                    current: modelData === Audio.source
                    accent: Theme.cyan
                    onClicked: Audio.setSource(modelData)
                }
            }
        }

        Section {
            visible: Audio.streams.length > 0
            title: "APPS"

            Repeater {
                model: Audio.streams

                Column {
                    required property var modelData
                    width: parent ? parent.width : 352
                    spacing: 4

                    StatRow {
                        label: Audio.label(modelData)
                        value: modelData.audio?.muted ? "mute" : Math.round((modelData.audio?.volume || 0) * 100) + "%"
                    }

                    Fader {
                        value: modelData.audio?.volume || 0
                        muted: !!modelData.audio?.muted
                        onMoved: n => {
                            if (modelData.audio)
                                modelData.audio.volume = n;
                        }
                    }
                }
            }
        }
    }
}
