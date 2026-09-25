# Optional: Waywallen extras

Not installed by default (**answer N** on the main installer prompt). Without
these extras, a fresh user keeps **Noctalia builtin** + stock Plasma
(**Breeze / BreezeClassic**) for GTK/Qt — no wallpaper palette bridge, no
`MaterialYouDark` generation.

The main `./install.sh` can ask once, or you use the scripts below anytime.
Enabling this path installs the wallpaper → **Noctalia + GTK + Qt** bridge;
the first wallpaper change generates the palette (you do not hand-craft a theme).

> Main `./install.sh` also skips existing rice files unless `FORCE=1`.
> Still prefer these scripts to toggle Waywallen only.

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

## GTK / Qt / KDE palette (same wallpaper)

`waywallen-noctalia-palette` also calls `waywallen-gtk-qt-palette` so GTK3/4,
KDE `MaterialYouDark`, and qt5ct pick up colors from the same cache image.

- Script: `~/.local/bin/waywallen-gtk-qt-palette`
- Helper: `~/.local/lib/waywallen-gtk-qt-palette-lib.py`
- Templates: `~/.config/waywallen/gtk-qt-palette-templates.toml` (gtk/kde/qt only — **no niri**)
- Disable GTK/Qt only: `touch ~/.config/waywallen/disable-gtk-qt-palette`
- First-run backup: `~/.local/backups/noctalia-gtk-qt-THEME-TIMESTAMP/`

Uses Noctalia’s built-in `theme` engine (matugen not required). Reopen GTK/Qt
apps after a wallpaper change. Flatpaks are usually unaffected.

