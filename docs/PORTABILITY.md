# Portability choices

1. No `output` blocks — connector names and modes are machine-specific.
2. No cursor theme/size — left for the user; NVIDIA cursor debug flags stay commented.
3. No layout pins — `open-on-output` assumes one person's dual-monitor map.
4. No game exe rules — keep those in a private local overlay.
5. No second-monitor autostart layout script.
6. Waywallen is **optional** — AppImage not vendored; bridge has no hardcoded
   connector (set `WAYWALLEN_MAIN_CONNECTOR` only if you need that fallback).
7. Autostart files use `@HOME@` rewrite, never a username path.
8. **No shipped GTK / Qt / `kdeglobals` / `MaterialYouDark`** — fresh users keep
   stock Plasma (Breeze / BreezeClassic) until they enable optional Waywallen
   extras (wallpaper-driven palette) or change colors themselves. Personal
   Noctalia palettes stay gitignored under `.config/noctalia/palettes/`.
8. Prefer `nwg-displays-niri` for monitor layout — it writes `cfg/outputs.kdl` (included), never personal connector blocks in the repo.
9. Discord tray is **optional** (`optional/discord-tray/`) — X11 Ozone wrapper
   + `@HOME@` desktop/autostart templates; never absolute `/home/<user>` Exec lines.
10. Middle-click autoscroll is **per-app only** on Niri/Wayland — do not ship or
    recommend global button2 stealers; leave Chromium/Helium/Vivaldi desktop
    overrides and Noctalia tray pins on the local machine.
