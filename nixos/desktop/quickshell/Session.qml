pragma Singleton
import Quickshell
import Quickshell.Hyprland

Singleton {
    function lock() {
        Run.detached(["hyprlock"]);
    }

    function sleep() {
        Quickshell.execDetached(["systemctl", "suspend"]);
    }

    function relaunch() {
        Hyprland.dispatch("exit");
    }

    function restart() {
        Quickshell.execDetached(["systemctl", "reboot"]);
    }

    function shutdown() {
        Quickshell.execDetached(["systemctl", "poweroff"]);
    }

    function run(id) {
        if (id === "lock")
            lock();
        else if (id === "sleep")
            sleep();
        else if (id === "relaunch")
            relaunch();
        else if (id === "restart")
            restart();
        else if (id === "shutdown")
            shutdown();
    }
}
