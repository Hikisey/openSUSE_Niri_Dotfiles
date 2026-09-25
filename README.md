# openSUSE Niri Dotfiles

Portable **openSUSE Tumbleweed** + **Niri** rice (optional Noctalia Shell).

**Who this is for:** a fresh openSUSE install with stock KDE Plasma — no prior
ricing, no personal dotfiles to preserve. First `./install.sh` lays down the
full desktop stack (Niri + helpers + optional Noctalia).

No personal monitors, cursor theme, window pinning, or game-specific rules.


## Install

```bash
git clone https://github.com/Hikisey/openSUSE_Niri_Dotfiles.git
cd openSUSE_Niri_Dotfiles
./install.sh
```

Prompts:

1. **Profile** — `full` (Noctalia) or `tech` (without Noctalia bits)
2. **Waywallen extras?** — only with `full`; palette bridge + systemd + autostart template (AppImage not included)

Skip package install:

```bash
SKIP_PACKAGES=1 ./install.sh
```

## After install

1. Configure monitors from `cfg/outputs.kdl.example`
2. Set cursor in `cfg/misc.kdl` if you want
3. Review keybinds for your apps
4. Point Noctalia at your real outputs
5. If you enabled Waywallen: put the AppImage at `~/Applications/waywallen.appimage`

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
- Optional Noctalia colors + shell config (monitor lists cleared)
- Kitty + Wayland helpers (screenshot / record / OCR / cast privacy / game-mode)
- `packages/zypper.txt`
- Optional Waywallen extras under `optional/waywallen/`

## Not included

- Monitor `output { }` blocks, cursor theme, layout pins, game window rules
- Wallpaper dumps / live palette caches
- Waywallen AppImage

## Portability

See [`docs/PORTABILITY.md`](docs/PORTABILITY.md).
