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
- Optional **Waywallen** extras under `optional/waywallen/` (asked during install)

## Not included (on purpose)

- `output { }` modes / positions / Hz
- Cursor theme / XCURSOR_*
- `open-on-output` layout pins
- Per-game window rules
- Second-monitor autostart layout scripts
- Wallpaper dumps / live palette caches
- Waywallen / Wallpaper Engine **AppImage** (download yourself)

## Install

```bash
git clone https://github.com/<YOU>/openSUSE_Niri_Dotfiles.git
cd openSUSE_Niri_Dotfiles
./install.sh
```

Prompts:

1. **Profile** — `full` (Noctalia) or `tech` (without Noctalia bits)
2. **Waywallen extras?** (only meaningful with `full`) — palette bridge + systemd units + autostart **template** (no AppImage)

Non-interactive:

```bash
DOTFILES_MODE=full INSTALL_WAYWALLEN=1 SKIP_PACKAGES=1 ./install.sh
```

## After install

1. Configure monitors from `cfg/outputs.kdl.example`
2. Set cursor in `cfg/misc.kdl` if you want
3. Review keybinds for your apps
4. Point Noctalia at your real outputs
5. If you enabled Waywallen extras: put the AppImage at `~/Applications/waywallen.appimage` (see `optional/waywallen/README.md`)

### Autostart template (Waywallen)

A template is a Desktop Entry with `@HOME@` placeholders. Install copies it to
`~/.config/autostart/waywallen.desktop` and rewrites paths. It does not download
Waywallen for you.

## Portability notes

See `docs/PORTABILITY.md`.
