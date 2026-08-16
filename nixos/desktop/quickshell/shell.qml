//@ pragma UseQApplication
import Quickshell
import Quickshell.Io

Scope {
    Bar {}
    Notifications {}

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            Launcher.toggle();
        }
        function power(): void {
            Launcher.openPower();
        }
    }
}
