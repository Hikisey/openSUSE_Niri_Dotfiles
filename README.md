# openSUSE Niri Dotfiles

Portable **openSUSE Tumbleweed** + **Niri** rice (optional Noctalia Shell).

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

## Waywallen without reinstalling the rice

Turn Off / On without running `./install.sh` again (that would overwrite your configs):

```bash
# Off → back to Noctalia wallpapers
./optional/waywallen/uninstall.sh

# On again later (only extras; Niri/Noctalia/Kitty stay as you left them)
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
