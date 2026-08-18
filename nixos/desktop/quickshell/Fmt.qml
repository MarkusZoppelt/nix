pragma Singleton
import Quickshell

Singleton {
    function bytes(n) {
        const v = Number(n) || 0;
        if (v >= 1099511627776)
            return (v / 1099511627776).toFixed(1) + "T";
        if (v >= 1073741824)
            return (v / 1073741824).toFixed(1) + "G";
        if (v >= 1048576)
            return (v / 1048576).toFixed(1) + "M";
        return Math.round(v / 1024) + "K";
    }

    function rate(bytesPerSec) {
        const bps = Math.max(0, Number(bytesPerSec) || 0) * 8;
        if (bps >= 1e9)
            return (bps / 1e9).toFixed(bps >= 1e10 ? 1 : 2) + " Gbps";
        if (bps >= 1e6)
            return (bps / 1e6).toFixed(bps >= 1e7 ? 1 : 2) + " Mbps";
        if (bps >= 1e3)
            return Math.round(bps / 1e3) + " Kbps";
        return Math.round(bps) + " bps";
    }

    function count(n) {
        const v = Number(n) || 0;
        if (v >= 1e6)
            return (v / 1e6).toFixed(1) + "M";
        if (v >= 1e3)
            return (v / 1e3).toFixed(1) + "K";
        return String(Math.round(v));
    }

    function clock(sec) {
        const s = Math.max(0, Math.floor(Number(sec) || 0));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }

    function eta(sec) {
        if (!(sec > 0))
            return "";
        const m = Math.round(sec / 60);
        if (m < 60)
            return m + "m";
        return Math.floor(m / 60) + "h " + (m % 60) + "m";
    }

    function wait(iso, now) {
        const ms = Date.parse(iso) - (now || Date.now());
        if (!(ms > 0))
            return "";
        const m = Math.floor(ms / 60000);
        const h = Math.floor(m / 60);
        const d = Math.floor(h / 24);
        if (d > 0)
            return "Resets in " + d + "d " + (h % 24) + "h";
        if (h > 0)
            return "Resets in " + h + "h " + (m % 60) + "m";
        return "Resets in " + Math.max(1, m) + "m";
    }
}
