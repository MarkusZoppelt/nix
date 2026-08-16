pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Singleton {
    readonly property var player: {
        const all = Mpris.players.values.filter(p => p.trackTitle || /spot|ncspot|mpv|mpd|vlc/i.test((p.identity || "") + (p.dbusName || "")));
        return all.find(p => p.isPlaying) || all[0] || null;
    }
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

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].concat(sinks).concat(sources).concat(streams)
    }
}
