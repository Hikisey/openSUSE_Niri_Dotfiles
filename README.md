# openSUSE Niri Dotfiles

Portable **openSUSE Tumbleweed** + **Niri** rice (optional Noctalia Shell).

Designed to share cleanly: **no personal monitors, no cursor theme/size, no per-machine window pinning, no game-specific rules**.

## Included

- Niri config split under `.config/niri/`
- Optional Noctalia colors + shell config (monitor lists cleared)
- Kitty config
- Wayland helpers (screenshot / record / OCR / cast privacy / game-mode)
- `packages/zypper.txt`
- `install.sh` (backups + `@HOME@` rewrite)

## Not included (on purpose)

- `output { }` modes / positions / Hz
- Cursor theme / XCURSOR_*
- `open-on-output` layout pins
- Per-game window rules
- Second-monitor autostart layout scripts
- Wallpaper dumps / live palette caches

## Install

```bash
git clone https://github.com/<YOU>/openSUSE_Niri_Dotfiles.git
cd openSUSE_Niri_Dotfiles
./install.sh
```

- `full` — with Noctalia
- `tech` — without Noctalia-specific bits

```bash
SKIP_PACKAGES=1 ./install.sh
```

## After install

1. Configure monitors from `cfg/outputs.kdl.example`
2. Set cursor in `cfg/misc.kdl` if you want
3. Review keybinds for your apps
4. Point Noctalia at your real outputs

## Portability notes

See `docs/PORTABILITY.md`.
