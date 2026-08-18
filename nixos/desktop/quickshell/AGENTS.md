# Quickshell

Tokyo Night bar + overlay shell. QML lives here; Nix copies it into `~/.config/quickshell` via `../quickshell.nix` and generates `Theme.qml` from `lib/colors.nix`.

## Layout

- Root `*.qml` singletons are **state** (`Net`, `Tail`, `Sync`, `Stats`, `Audio`, `Fmt`, `Popups`). Filename = type name. Auto-discovered by Quickshell.
- `widgets/` are bar chips. `ui/` is shared chrome. Widgets import `".."` + `"../ui"`.
- Name collisions are avoided by suffixing: `Tail.qml` + `widgets/Tailnet.qml`, `Sync.qml` + `widgets/Syncthing.qml`.

## Visual rules

- Palette is Tokyo Night. Prefer `Theme.fg` / `Theme.fgDark` / `Theme.comment` for text. Accent colors (`blue`, `magenta`, `cyan`, `green`) are for marks, meters, and wells — not body copy.
- Never `property color x: Theme.fg`. QML evaluates that once at create time and it freezes to black if Theme is not ready. Use `property alias color: label.color` and set `label.color: Theme.fg`, or `property var ink` and bind `color: ink || Theme.fg`.
- Bar glyphs are ~15px, monochrome, vertically centered with Chip text. Official marks (Tailscale 3×3, Syncthing ring+hub) stay one-color.
- Panels are `PanelCard`. Inset groups use `Well`. Lists use `Choice` only when they are actions; read-only rows are `StatRow`.
- One popup at a time (`Popups`). Panels grow to content up to remaining screen height.

## Code rules

- Import `QtQuick` anywhere you use `Timer`, `Behavior`, or `NumberAnimation`. `Process` cannot host a `Timer` — wrap both in `ui/Poll.qml`.
- New files must be `git add`ed before `nh os switch`. Flakes ignore untracked paths, so QML will reference a type that is not in the store.
- After a failed reload, IPC dies (`Not ready to accept queries yet`). Restart with `systemctl --user reset-failed quickshell.service && systemctl --user restart quickshell.service`. Do not restart if Steam is a child of the old cgroup.
- After a successful rebuild, apply from the existing herdr split: `nh os switch --diff=always && qs ipc call shell reload`.
- Poll expensive commands only while the panel is open (`Stats.hot`, `Net.scan`). Keep secrets out of argv; talk to local APIs from QML (XHR), not helper scripts.
- Shared formatters live in `Fmt`. Shared on/off chrome is `Pills { binary: true }`.

## Adding a widget

1. State singleton at repo root if it needs polling or IPC.
2. Chip in `widgets/`, using `PanelCard` + `Heading` + existing `ui/` bits.
3. Mount it in `Bar.qml`.
4. Stage the new files, switch, reload.

## Do not

- Copy Omarchy panels wholesale. Steal behavior, keep this chrome.
- Generate widgets from Nix. Only `Theme.qml` is generated.
- Put Linux-only packages in `home.nix`; add them in `quickshell.nix`.
