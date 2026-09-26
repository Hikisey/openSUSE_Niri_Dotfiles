# openSUSE Niri Dotfiles

Portable **openSUSE Tumbleweed** + **Niri** rice (optional Noctalia Shell).

**Who this is for:** a fresh openSUSE install with stock KDE Plasma — no prior
ricing, no personal dotfiles to preserve. First `./install.sh` lays down the
full desktop stack (Niri + helpers + optional Noctalia).

No personal monitors, cursor theme, layout pinning, or game-specific rules.


## Install

```bash
git clone https://github.com/Hikisey/openSUSE_Niri_Dotfiles.git
cd openSUSE_Niri_Dotfiles
./install.sh
```

Prompts:

1. **Profile** — `full` (Noctalia) or `tech` (without Noctalia bits)
2. **Waywallen extras?** — only with `full`; default **No**. Installs the
   wallpaper → Noctalia + GTK + Qt palette bridge, systemd units, and an
   autostart template (AppImage **not** included)

Skip package install:

```bash
SKIP_PACKAGES=1 ./install.sh
```

## Theme / default look (fresh install)

You do **not** need to hand-craft a theme (no manual `MaterialYouDark`, no
custom `kdeglobals` editing). Pick a path and the palette follows wallpaper.

| Path | What you get |
|------|----------------|
| **Stock Plasma before this rice** | openSUSE default Look-and-Feel: **Breeze** + **BreezeClassic** (light-leaning). Some installs use Breeze Light / Dark if you changed it in Settings. |
| **After `./install.sh`, Waywallen = No** (default) | **Noctalia** uses its **built-in** soft look until you set a wallpaper in Noctalia; then Noctalia can derive a **wallpaper soft** palette itself. **GTK / Qt / KDE** stay stock Plasma (**Breeze** / **BreezeClassic**) — this rice does **not** copy `kdeglobals`, GTK CSS, or qt5ct colors. Niri focus/border accents in the full profile are a fixed soft dark gray (`noctalia.kdl`). |
| **After `./install.sh`, Waywallen = Yes** (optional) | Same rice + bridge: when Waywallen’s active wallpaper changes, colors update for **Noctalia + GTK3/4 + KDE (`MaterialYouDark`) + qt5ct** from that image. First wallpaper change generates the palette — no theme authoring. |

Summary:

- **Without Waywallen** → Noctalia builtin / Breeze-ish apps; change a Noctalia wallpaper if you want a matching shell palette.
- **With Waywallen** → wallpaper-driven palette for Noctalia + GTK + Qt (optional path only).

Details: [`optional/waywallen/README.md`](optional/waywallen/README.md).

## After install

1. Open **Display Settings (nwg-displays)** from the app menu (or run `nwg-displays-niri`).
   Arrange monitors like in Windows → Apply/Save. Layout is written to
   `~/.config/niri/cfg/outputs.kdl` and survives reboot. Hand-edit
   `cfg/outputs.kdl.example` only if you prefer editing KDL yourself.
2. Set cursor in `cfg/misc.kdl` if you want
3. Review keybinds for your apps
4. Point Noctalia at your real outputs
5. If you enabled Waywallen: put the AppImage at `~/Applications/waywallen.appimage`
6. Theme: no manual palette file needed — see **Theme / default look** above

## Fresh install vs re-run

On a **new** openSUSE + stock Plasma machine there is nothing to clash with —
`./install.sh` writes the full rice.

If you run it again later (or already customized configs), it **skips existing
files** by default so it does not wipe your edits. To force rice defaults back
(old files get `.bak.<timestamp>`):

```bash
FORCE=1 ./install.sh
```

## Waywallen on / off

Prefer the dedicated scripts (they only touch Waywallen extras):

```bash
# Off → back to Noctalia wallpapers
./optional/waywallen/uninstall.sh

# On again (extras only; rice configs untouched)
./optional/waywallen/install.sh
```

Details: [`optional/waywallen/README.md`](optional/waywallen/README.md).

## Included

- Niri config under `.config/niri/`
- Optional Noctalia shell config (monitor lists cleared; **no** shipped color
  scheme / `MaterialYouDark` / GTK-Qt files)
- Kitty + Wayland helpers (screenshot / record / OCR / cast privacy / game-mode)
- `nwg-displays` + `nwg-displays-niri` (GUI monitor layout → `cfg/outputs.kdl`)
- `packages/zypper.txt`
- Optional Waywallen extras under `optional/waywallen/` (palette + GTK/Qt bridge)
- Optional Discord tray (X11 Ozone wrapper) under `optional/discord-tray/`

## Not included

- Monitor `output { }` blocks, cursor theme, layout pins, game window rules
- Wallpaper dumps / live palette caches
- Hand-crafted `MaterialYouDark` / `kdeglobals` / GTK / qt5ct themes
- Waywallen AppImage
- Discord tray / Chromium desktop overrides (install from `optional/discord-tray/` if wanted)
- Personal Noctalia tray pin lists, monitors, cursor, game window rules

## Discord tray / middle-click (optional)

```bash
./optional/discord-tray/install.sh
```

Forces X11 Ozone so Discord registers a tray icon; documents per-app
middle-click autoscroll (no global Win32-style scroll on Niri/Wayland).
Details: [`optional/discord-tray/README.md`](optional/discord-tray/README.md).

## Portability

See [`docs/PORTABILITY.md`](docs/PORTABILITY.md).
