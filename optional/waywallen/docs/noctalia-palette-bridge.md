# Waywallen → Noctalia palette bridge

When Waywallen’s **active** wallpaper changes, this bridge copies that item’s
Steam Workshop **preview** into `~/.cache/noctalia/waywallen-main.jpg` and tells
Noctalia to derive its palette from that file.

Noctalia’s own wallpaper **drawing stays off** (`[wallpaper] enabled = false`).
Waywallen remains the visual wallpaper.

## Resolution order (active wallpaper)

1. **Running renderers** (best): `pgrep` for `waywallen-wescene-renderer` /
   `waywallen-weweb-renderer`, parse `--workshop_id N` or path `…/431960/N/`.
   Prefer **wescene** over **weweb**; if several scenes, prefer the one matching
   `[global] last_wallpaper`’s `external_id`. Map workshop id → `item` via
   sqlite `item.external_id`.
2. Else **config**: `[global] last_wallpaper`, then newest `display.layer-*`
   sections (prefer a scene-ish item when several layers exist).
3. Else named `:DP-2` display section (stale under Niri layer-shell — last resort).

State key is `w:<workshop_id>` when known (else `i:<item_id>`). Same key with a
missing/empty cache still re-applies. `--force` ignores state.

After `wallpaper-set`, the script runs `noctalia msg color-scheme-set wallpaper soft`
and `config-reload` so the same cache path still refreshes the palette.

## Units

- `waywallen-noctalia-palette.path` — watches `~/.config/waywallen/config.toml`
- `waywallen-noctalia-palette.timer` — every ~45s (cheap: pgrep + state compare)
- `waywallen-noctalia-palette.service` — oneshot runner for the script
- Script: `~/.local/bin/waywallen-noctalia-palette`
- Log: `~/.local/state/waywallen-noctalia-palette.log`
- State: `~/.local/state/waywallen-noctalia-palette.state`

## Revert

```bash
systemctl --user disable --now \
  waywallen-noctalia-palette.path \
  waywallen-noctalia-palette.timer \
  waywallen-noctalia-palette.service
# optional: remove units
# rm ~/.config/systemd/user/waywallen-noctalia-palette.{path,timer,service}
# systemctl --user daemon-reload

# Restore previous theme (before bridge):
noctalia msg color-scheme-set custom wallhaven-1q2zd1-sft

# Keep wallpaper drawing disabled:
# [wallpaper] enabled = false   (do not turn on)

# Optional: restore settings.toml backup (timestamped):
# ls ~/.local/state/noctalia/settings.toml.bak-before-waywallen-palette-bridge-*
# cp -a ~/.local/state/noctalia/settings.toml.bak-before-waywallen-palette-bridge-YYYYMMDD-HHMMSS \
#    ~/.local/state/noctalia/settings.toml
# noctalia msg config-reload
```

Previous theme before install: `source=custom`, `custom_palette=wallhaven-1q2zd1-sft`,
`wallpaper_scheme=soft`, `[wallpaper] enabled=false`.

## Caveats

- Palette comes from the Workshop **preview** (often a GIF first frame), not a
  live rendered Waywallen frame — colors can differ from what you see on screen.
- Named `:DP-2` alone is unreliable under Niri layer-shell; process/global/layer
  resolution is preferred.
- Idempotent on workshop/item key; empty cache forces re-apply.

## Manual run / force

```bash
waywallen-noctalia-palette --force
# or:
rm -f ~/.local/state/waywallen-noctalia-palette.state && waywallen-noctalia-palette

noctalia msg color-scheme-get   # expect: wallpaper soft
```

If `soft` looks wrong for a wallpaper, try:
`noctalia msg color-scheme-set wallpaper faithful`
or `… m3-content` (script default remains `soft` via `NOCTALIA_WALLPAPER_SCHEME`).


## Optimizations (2026-09-25)

- Preview candidates ranked: non-gif first, then larger files.
- Tiny / gif sources upscaled to ≥1024px long side (Lanczos) before matugen.
- Optional wallhaven-1q2zd1 enrichment for known Blue Sky (2944773634) gif-only case.
- State file stores `STATE_KEY sha256:…` so preview content changes re-apply without `--force`.
- Timer poll: `OnUnitActiveSec=5min` (path unit remains primary trigger).

## GTK / Qt / KDE extension

After Noctalia’s wallpaper palette updates, the same cache image is passed to
`waywallen-gtk-qt-palette`, which:

1. Runs `noctalia theme <image> --scheme soft --dark` with a **narrow** template
   config (`~/.config/waywallen/gtk-qt-palette-templates.toml`) for **gtk3,
   gtk4, kcolorscheme, qt only** (no niri / compositor templates).
2. Writes Breeze-compatible `~/.config/gtk-3.0/colors.css` and `gtk-4.0/colors.css`
   (your GTK theme is Breeze; Adwaita-style `noctalia.css` is also imported).
3. Regenerates `~/.local/share/color-schemes/MaterialYouDark.colors` and merges
   `Colors:*` into `~/.config/kdeglobals` (keeps `ColorScheme=MaterialYouDark`).
4. Points `qt5ct` at `~/.config/qt5ct/colors/noctalia.conf` (`custom_palette=true`).

First write backs up prior files to:
`~/.local/backups/noctalia-gtk-qt-THEME-TIMESTAMP/`.

### Disable GTK/Qt apply only (keep Noctalia bridge)

```bash
touch ~/.config/waywallen/disable-gtk-qt-palette
# optional immediate undo of noctalia.css imports:
# bash /usr/share/noctalia/assets/templates/gtk/undo-gtk3.sh
# bash /usr/share/noctalia/assets/templates/gtk/undo-gtk4.sh
# Restore from backup if needed:
# ls ~/.local/backups/noctalia-gtk-qt-THEME-*
```

### Manual / force GTK+Qt

```bash
waywallen-gtk-qt-palette --force
# or via the full bridge:
waywallen-noctalia-palette --force
```

### Restart needed

- **GTK apps**: reopen (or rely on `colorreload-gtk-module` where present).
- **Qt/KDE (Dolphin, Kate, …)**: reopen; with `QT_QPA_PLATFORMTHEME=qt5ct` they
  read the new qt5ct color scheme on next start. Apps using `gtk3` platformtheme
  follow GTK colors instead.
- **Flatpak**: usually isolated; may need flatpak overrides / portals — not wired.

### Limitations

- Palette still comes from the Workshop **preview**, not a live Waywallen frame.
- `matugen` is **not** required; Noctalia’s built-in `theme` engine is used.
- Do not enable Noctalia `[wallpaper] enabled = true` (Waywallen draws).

## Fix: purple desync (2026-09-26)

Root cause: on boot the bridge could encode a **transient** Day/Night
(`1373816444`) purple `preview.jpg` into `waywallen-main.jpg`, then fail while
Noctalia IPC was still down. Later runs resolved Blue Sky (`2944773634`) whose
**source** hash matched state, so the "unchanged" short-circuit never repaired
the purple cache. UI accents stayed purple (`#9a8ac2`) despite Blue Sky's blue
`preview.gif`.

Changes:
- Default `wallpaper_scheme` / `NOCTALIA_WALLPAPER_SCHEME` → **`m3-content`**
- State now stores `sha256:<src> cache:<jpg> scheme:<name>`; mismatch forces re-apply
- Wait for Noctalia IPC before apply (boot race)
- Wallhaven enrichment for Blue Sky is **opt-in** (`WAYWALLEN_PALETTE_ENRICH_ENABLE=1`)
- Noctalia wallpaper **drawing stays off** (`[wallpaper] enabled = false`)

No plugin required — v5+ native `source = "wallpaper"` is enough; this bridge
only feeds Waywallen's current preview path into Noctalia.
