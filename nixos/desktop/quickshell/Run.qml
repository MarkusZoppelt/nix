pragma Singleton
import Quickshell

Singleton {
    function argv(cmd) {
        const out = [];
        if (typeof cmd === "string") {
            if (cmd)
                out.push(cmd);
            return out;
        }
        const n = cmd ? cmd.length : 0;
        if (typeof n !== "number")
            return out;
        for (let i = 0; i < n; i++) {
            const a = String(cmd[i] ?? "");
            if (!a || a.includes("\0") || /^%[a-zA-Z]$/.test(a))
                continue;
            out.push(a);
        }
        return out;
    }

    function detached(cmd, cwd) {
        const list = argv(cmd);
        if (!list.length)
            return;
        const bin = list[0];
        if (bin[0] === "-" || bin[0] === ".")
            return;
        const args = [Theme.systemdRun, "--user", "--scope", "--collect", "--quiet"];
        if (cwd && cwd[0] === "/" && !cwd.includes("\0") && !cwd.includes("\n") && !cwd.includes("://"))
            args.push("-p", "WorkingDirectory=" + cwd);
        args.push("--");
        Quickshell.execDetached(args.concat(list));
    }

    function term(cmd) {
        const rest = argv(cmd);
        if (!rest.length)
            return;
        detached(["ghostty", "+new-window", "-e"].concat(rest));
    }
}
