---
name: qs-widget
description: Add or change a Quickshell bar chip or overlay. Use when the user asks for a new widget, panel, overlay, or chrome change in nixos/desktop/quickshell/.
---

# Quickshell widgets

Read `nixos/desktop/quickshell/AGENTS.md` first. Use existing chrome. Do not invent a second card or button style. Do not add a plugin loader, `$HOME` QML scan, or generated widget QML.

## Layout

```
nixos/desktop/quickshell/
  *.qml            # singletons (state). Filename = type name.
  widgets/*.qml    # bar chips. Mount in Bar.qml.
  ui/*.qml         # shared chrome.
```

Widgets import `".."` and `"../ui"`. Avoid type-name collisions (`Tail.qml` + `widgets/Tailnet.qml`).

## Add a chip

1. State singleton at repo root if it needs polling or IPC.
2. Chip in `widgets/`, using `PanelCard` + `Heading` + existing `ui/` bits.
3. Mount it in `Bar.qml`.
4. Stage the new files. Flakes ignore untracked paths. Do not `nh os switch` unless asked.

```qml
import ".."
import "../ui"

Chip {
    id: root
    color: Theme.orange
    text: "󰒳"
    onClicked: panel.toggle(root)

    PanelCard {
        id: panel
        Heading { title: "…" }
        Switch { label: "…"; on: …; onToggled: … }
        Btn { text: "Do it"; kind: "primary"; onClicked: … }
    }
}
```

## Chrome

| Want | Use |
| --- | --- |
| Bar glyph | `Chip` |
| Popup | `PanelCard` + `Popups` (one at a time) |
| Title | `Heading` |
| Group | `Section`, inset `Well` |
| Action row | `Choice` |
| Read-only row | `StatRow` |
| On/off | `Switch` |
| Button | `Btn` (`ghost` / `primary` / `danger`) |
| Context menu | `Menu` (`items: [{ text, danger, separator, enabled }]`) |
| Text field | `Field` |
| Poll a command | `ui/Poll.qml` |
| Launch a GUI | `Run.detached` |
| Terminal app | `Run.term` |
| Session verb | `Session.run` |
| Untrusted text | `Text.PlainText` |

Never `property color x: Theme.fg` (freezes black). Bind `color: Theme.fg` on the Text, or `property var ink`.

Poll only while the panel is open. Keep secrets out of argv. Talk to localhost APIs from QML (XHR), not helper scripts.

Linux-only packages go in `quickshell.nix`, not `home.nix`.

## Security

- No runtime `import` of `$HOME` QML.
- `Run.detached` rejects `-`/`.` argv0, NULs, and relative cwd. Always `--`.
- Folder clicks go through `Theme.openDir`.
- Image URLs go through `Fmt.imageUrl`.
