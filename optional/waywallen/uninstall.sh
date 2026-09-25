#!/usr/bin/env bash
# Remove Waywallen extras and point the user back to Noctalia / Niri wallpapers.
set -euo pipefail
HOME_DIR="${HOME:?}"

echo "Disabling Waywallen → Noctalia palette bridge…"
systemctl --user disable --now \
  waywallen-noctalia-palette.path \
  waywallen-noctalia-palette.timer \
  waywallen-noctalia-palette.service 2>/dev/null || true

rm -f \
  "$HOME_DIR/.config/systemd/user/waywallen-noctalia-palette.path" \
  "$HOME_DIR/.config/systemd/user/waywallen-noctalia-palette.service" \
  "$HOME_DIR/.config/systemd/user/waywallen-noctalia-palette.timer"
systemctl --user daemon-reload 2>/dev/null || true

rm -f "$HOME_DIR/.config/autostart/waywallen.desktop"

# Keep bridge / GTK-Qt binaries unless asked — easy to re-enable later.
if [[ "${REMOVE_BRIDGE_BIN:-0}" == 1 ]]; then
  rm -f "$HOME_DIR/.local/bin/waywallen-noctalia-palette"
  rm -f "$HOME_DIR/.local/bin/waywallen-gtk-qt-palette"
  rm -f "$HOME_DIR/.local/lib/waywallen-gtk-qt-palette-lib.py"
fi

# Always drop the GTK/Qt enablement flag and template config pointer used by the sibling.
rm -f "$HOME_DIR/.config/waywallen/disable-gtk-qt-palette"
# Keep gtk-qt-palette-templates.toml unless FORCE remove:
if [[ "${REMOVE_BRIDGE_BIN:-0}" == 1 ]]; then
  rm -f "$HOME_DIR/.config/waywallen/gtk-qt-palette-templates.toml"
fi

echo
echo "Extras removed (AppImage under ~/Applications is left alone)."
echo "GTK/Qt theme files in ~/.config/gtk-*/ and kdeglobals are NOT reverted."
echo "Restore from: ls ~/.local/backups/noctalia-gtk-qt-THEME-*"
echo "Or disable future GTK/Qt applies: touch ~/.config/waywallen/disable-gtk-qt-palette"
echo
echo "Restore Noctalia wallpapers:"
echo "  1. Stop Waywallen if it is still running (killall waywallen || true)."
echo "  2. In Noctalia Settings → Wallpaper: turn drawing ON,"
echo "     or run:"
echo "       noctalia msg wallpaper enable    # if your build supports it"
echo "     Otherwise edit settings and set [wallpaper] enabled = true,"
echo "     then: noctalia msg config-reload"
echo "  3. Pick a wallpaper: Mod+Shift+Return (wallpaper panel) or"
echo "       noctalia msg panel-toggle wallpaper"
echo "  4. Optional palette from that image:"
echo "       noctalia msg color-scheme-set wallpaper soft"
echo
echo "Niri itself does not draw wallpapers — Noctalia (or swww/hyprpaper/etc.) does."
echo "Done."
