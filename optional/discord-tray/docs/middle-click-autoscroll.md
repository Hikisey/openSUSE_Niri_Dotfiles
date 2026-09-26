# Middle-click autoscroll on Niri / Wayland

## Honest limits

There is **no** global Windows-style middle-click autoscroll on Niri/Wayland.
Compositors do not provide a desktop-wide “hold button2 → auto-pan” like
classic Win32. You enable it **per app** (or accept that some toolkits never
expose it).

**Do not** install a global `midscroll`-style interceptor that steals
button2. Games and many native apps need middle-click (pan, paste, bind).
A compositor-wide grab is a bad default for a gaming rice.

## Chromium / Electron / Helium

| App | Flag / setting |
|-----|----------------|
| Chromium / most Electron | `--enable-blink-features=MiddleClickAutoscroll` on the Exec line |
| Helium | `--enable-features=HeliumMiddleClickAutoscroll` |
| Discord (this optional) | same Blink flag, already in `discord-tray` |

Edit your **local** `.desktop` overrides under `~/.local/share/applications/`
only — those files are machine-specific and are **not** shipped in this rice.

Example (Chromium Exec fragment):

```text
chromium-browser --enable-blink-features=MiddleClickAutoscroll %U
```

## Discord + Vencord

1. Launch via `discord-tray` (X11 Ozone + Blink MiddleClickAutoscroll).
2. If middle-click pastes into the message box instead of scrolling, enable
   Vencord plugin **NoMiddleClickPaste** (Settings → Vencord → Plugins).

## Firefox / Zen (Gecko)

In `about:config` (or prefs):

```text
general.autoScroll = true
```

No desktop-file flag required.

## What this rice ships vs leaves local

| Portable (repo) | Local-only (do not commit) |
|-----------------|----------------------------|
| `optional/discord-tray/` wrapper + templates | Absolute `/home/<user>/…` Exec lines |
| This doc | Personal Chromium / Vivaldi / Anytype / Helium `.desktop` overrides |
| README / PORTABILITY notes | Noctalia `widget.tray` pinned list (e.g. Discord only) |
| | Monitors, cursor, game window rules |
