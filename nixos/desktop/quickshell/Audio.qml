pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Singleton {
    id: root
    readonly property var player: {
        const all = Mpris.players.values.filter(p => p.trackTitle || /spot|ncspot|mpv|mpd|vlc/i.test((p.identity || "") + (p.dbusName || "")));
        return all.find(p => p.isPlaying) || all[0] || null;
    }
    readonly property bool playing: !!player?.isPlaying
    property var eq: []
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.audio && n.isSink && !n.isStream)
    readonly property var sources: Pipewire.nodes.values.filter(n => n.audio && !n.isSink && !n.isStream)
    readonly property var streams: Pipewire.nodes.values.filter(n => n.audio && n.isStream && n.isSink)

    function label(n) {
        const p = n?.properties || {};
        return p["application.name"] || n?.nickname || n?.description || n?.name || "audio";
    }

    function setSink(n) {
        Pipewire.preferredDefaultAudioSink = n;
    }

    function setSource(n) {
        Pipewire.preferredDefaultAudioSource = n;
    }

    Timer {
        interval: 1000
        running: root.playing
        repeat: true
        onTriggered: root.player?.positionChanged()
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].concat(sinks).concat(sources).concat(streams)
    }

    Process {
        running: root.playing
        command: ["stdbuf", "-oL", "cava", "-p", Theme.cava]
        stdout: SplitParser {
            onRead: data => {
                const next = data.split(";").map(Number).filter(n => !isNaN(n));
                if (next.length)
                    root.eq = next;
            }
        }
        onRunningChanged: if (!running)
            root.eq = []
    }
}
