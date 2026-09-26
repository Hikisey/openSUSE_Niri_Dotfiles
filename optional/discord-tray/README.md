# Optional: Discord tray (X11 Ozone) + middle-click notes

Not installed by the main `./install.sh`. Use the scripts below if you want
Discord’s StatusNotifier tray icon on Niri/Noctalia and optional per-app
middle-click autoscroll flags documented next to it.

## Why a wrapper?

Discord (Electron) on pure Wayland often **does not** register a tray /
StatusNotifierItem icon. Forcing the **X11 Ozone** platform makes the tray
appear:

```text
ELECTRON_OZONE_PLATFORM_HINT=x11
--ozone-platform=x11
```

**Autostart and `.desktop` launches must call this wrapper**, not bare
`/usr/bin/discord`. Otherwise you get a session without a tray icon.

The wrapper also passes `--enable-blink-features=MiddleClickAutoscroll`
(Discord/Chromium middle-click pan). That is **per-app only** — see
[`docs/middle-click-autoscroll.md`](docs/middle-click-autoscroll.md).

## Quick use

```bash
# Enable (does NOT touch Niri / Noctalia rice configs)
./optional/discord-tray/install.sh

# Remove wrapper + desktop overrides this optional installed
./optional/discord-tray/uninstall.sh
```

`install.sh` rewrites `@HOME@` placeholders — never commit a username path.

Override the binary if needed:

```bash
export DISCORD_BIN="$HOME/.config/discord/app-1.0.159/Discord"
# or re-run after editing ~/.local/bin/discord-tray
```

## What gets installed

1. `~/.local/bin/discord-tray`
2. `~/.local/share/applications/discord.desktop` (menu / protocol handler)
3. `~/.config/autostart/discord.desktop` (optional login autostart)

## Dependencies

Packaged Discord (`/usr/bin/discord`) or any binary you set via `DISCORD_BIN`.
XWayland must be available (Niri typically runs `xwayland-satellite` or similar).

## Caveats

- Tray reliability trades off native Wayland; this path intentionally uses X11 Ozone.
- Global Windows-style autoscroll is **not** available on Niri/Wayland — do not
  recommend tools that steal button2 from games.
- Pinning Discord in Noctalia’s tray widget is personal UI preference — not shipped.
