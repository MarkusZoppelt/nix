pragma Singleton
import Quickshell

Singleton {
    function detached(cmd, cwd) {
        if (!cmd || !cmd.length || cmd[0][0] === "-" || cmd[0][0] === ".")
            return;
        const args = [Theme.systemdRun, "--user", "--scope", "--collect", "--quiet"];
        if (cwd && cwd[0] === "/" && !cwd.includes("\0") && !cwd.includes("\n") && !cwd.includes("://"))
            args.push("-p", "WorkingDirectory=" + cwd);
        args.push("--");
        Quickshell.execDetached(args.concat(cmd));
    }
}
