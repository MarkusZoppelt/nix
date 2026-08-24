pragma Singleton
import Quickshell

Singleton {
    function detached(cmd, cwd) {
        const args = [Theme.systemdRun, "--user", "--scope", "--collect", "--quiet"];
        if (cwd)
            args.push("-p", "WorkingDirectory=" + cwd);
        Quickshell.execDetached(args.concat(cmd));
    }
}
