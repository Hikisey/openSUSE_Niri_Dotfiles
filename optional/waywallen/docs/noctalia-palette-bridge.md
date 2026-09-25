# Waywallen → Noctalia palette bridge

When Waywallen’s **active** wallpaper changes, this bridge copies that item’s
Steam Workshop **preview** into `~/.cache/noctalia/waywallen-main.jpg` and tells
Noctalia to derive its palette from that file.

Noctalia’s own wallpaper **drawing stays off** (`[wallpaper] enabled = false`).
Waywallen remains the visual wallpaper.

## Resolution order

1. Running renderers (`waywallen-wescene-renderer` / `waywallen-weweb-renderer`)
2. `[global] last_wallpaper` / newest `display.layer-*`
3. Optional named connector section — only if `WAYWALLEN_MAIN_CONNECTOR` is set
   (often stale under Niri layer-shell; leave unset unless you need it)

## Units

- `waywallen-noctalia-palette.path` — watches `~/.config/waywallen/config.toml`
- `waywallen-noctalia-palette.timer` — every ~45s (cheap: pgrep + state compare)
- `waywallen-noctalia-palette.service` — oneshot runner
- Script: `~/.local/bin/waywallen-noctalia-palette`
- Log: `~/.local/state/waywallen-noctalia-palette.log`

## Caveats (not “fixed” by this repo)

- Palette comes from the Workshop **preview**, not a live rendered frame.
- Waywallen / Wallpaper Engine itself can still stutter or mis-detect displays —
  this optional pack only adds the palette bridge + autostart template.
- For competitive FPS you may still want to pause/stop Waywallen in games.

## Revert

```bash
systemctl --user disable --now \
  waywallen-noctalia-palette.path \
  waywallen-noctalia-palette.timer \
  waywallen-noctalia-palette.service
```

## Manual / force

```bash
waywallen-noctalia-palette --force
```
