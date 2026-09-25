# Optional: Waywallen extras

**Not installed by default.** `./install.sh` asks whether you want this.

## What this is

Waywallen is a Linux Wallpaper Engine client (AppImage). This folder does **not**
ship the binary. It only adds:

1. **Palette bridge** — when the active Waywallen wallpaper changes, update
   Noctalia’s color scheme from the Workshop preview (without turning on
   Noctalia’s own wallpaper drawing).
2. **systemd user units** — path watch + ~45s timer that run the bridge.
3. **Autostart template** — a `.desktop` file for XDG autostart that launches
   Waywallen with `--no-ui` at login.

### What is an “autostart template”?

On Linux, apps that should start after login often put a small file in
`~/.config/autostart/` (Desktop Entry). A **template** means the repo keeps a
generic version with `@HOME@` placeholders instead of a hard-coded username or
AppImage path. `install.sh` copies it to `~/.config/autostart/waywallen.desktop`
and rewrites `@HOME@` to your real home. You still must download the AppImage
to `~/Applications/waywallen.appimage` (or edit Exec/TryExec).

## Install (via main install.sh)

Answer **yes** to the Waywallen question, or:

```bash
INSTALL_WAYWALLEN=1 ./install.sh
```

Then:

1. Put `waywallen.appimage` in `~/Applications/` (and optionally an icon under
   `~/Applications/.icons/waywallen`).
2. Log out/in (or start the AppImage once) so Waywallen creates its config/DB.
3. Optional: `export WAYWALLEN_MAIN_CONNECTOR=DP-1` only if you need the
   connector fallback (usually leave unset).
4. Check: `systemctl --user status waywallen-noctalia-palette.timer`

## Dependencies

`sqlite3`, `noctalia`, and one of `magick` / `convert` / `ffmpeg`.

## Rollback — remove Waywallen, return to Noctalia wallpapers

Niri does not paint wallpapers by itself. After Waywallen is gone you want
**Noctalia wallpaper drawing** (or another wallpaper daemon) again.

```bash
# from a clone of this repo:
./optional/waywallen/uninstall.sh

# also remove the bridge binary:
REMOVE_BRIDGE_BIN=1 ./optional/waywallen/uninstall.sh
```

What that does:

- disables/stops the palette path + timer + service
- removes those systemd user units
- removes `~/.config/autostart/waywallen.desktop`

Then manually:

1. Quit Waywallen (`killall waywallen` or from its tray/UI).
2. Turn Noctalia wallpaper **on** (`[wallpaper] enabled = true`) and reload.
3. Open the wallpaper panel (`Mod+Shift+Return` in this rice) and pick an image.
4. Optional: `noctalia msg color-scheme-set wallpaper soft`

The AppImage under `~/Applications/` is **not** deleted (you may want it later).
Delete it yourself if you are done with Wallpaper Engine.

### Caveats this does not fix

Waywallen / Wallpaper Engine bugs (FPS, wrong display, stuck workshop id) are
upstream. Rollback only removes **our** bridge and autostart so Noctalia can
own the desktop background again.

## Disable (keep files)

```bash
systemctl --user disable --now \
  waywallen-noctalia-palette.path \
  waywallen-noctalia-palette.timer
rm -f ~/.config/autostart/waywallen.desktop
```
