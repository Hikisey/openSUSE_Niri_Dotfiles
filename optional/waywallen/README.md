# Optional: Waywallen extras

Not installed by default. The main `./install.sh` can ask once, or you use the
scripts below anytime.

## Quick use

```bash
# Enable (does NOT touch Niri / Noctalia / Kitty rice files)
./optional/waywallen/install.sh

# Disable → return to Noctalia wallpapers
./optional/waywallen/uninstall.sh
```

After uninstall, quit Waywallen and turn Noctalia wallpaper drawing back on.
After install again, turn Noctalia wallpaper drawing off so Waywallen owns the
desktop. Your rice configs are left alone either way.

## What gets installed

1. **Palette bridge** — `~/.local/bin/waywallen-noctalia-palette`
2. **systemd user units** — path + timer for the bridge
3. **Autostart desktop file** — from a template with `@HOME@` rewritten

AppImage is **not** shipped. Put it at `~/Applications/waywallen.appimage`.

### Autostart template

A Desktop Entry for `~/.config/autostart/`. The repo keeps `@HOME@` placeholders;
`install.sh` rewrites them. Edit Exec if your AppImage lives elsewhere.

## Dependencies

`sqlite3`, `noctalia`, and one of `magick` / `convert` / `ffmpeg`.

## Re-enable after uninstall

```bash
./optional/waywallen/install.sh
```

Same as first enable: only extras. No second full rice install.

Optional connector fallback (usually leave unset):

```bash
export WAYWALLEN_MAIN_CONNECTOR=DP-1
```

## Disable without deleting the script

```bash
systemctl --user disable --now \
  waywallen-noctalia-palette.path \
  waywallen-noctalia-palette.timer
rm -f ~/.config/autostart/waywallen.desktop
```

## Caveats

Waywallen / Wallpaper Engine bugs are upstream. These extras only add the
palette bridge and autostart helpers.
