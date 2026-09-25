#!/usr/bin/env bash
# Install ONLY Waywallen extras (bridge + systemd + autostart).
# Does not copy or overwrite Niri/Noctalia/Kitty dotfiles.
set -euo pipefail
OPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME is not set}"
STAMP="$(date +%Y%m%d-%H%M%S)"
FORCE="${FORCE:-0}"

backup() {
  local f="$1"
  if [[ -e "$f" && ! -L "$f" ]]; then
    mv -- "$f" "$f.bak.$STAMP"
  fi
}

write_rewritten() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && "$FORCE" != 1 ]]; then
    echo "keep existing: $dst"
    return 0
  fi
  mkdir -p "$(dirname -- "$dst")"
  if [[ -e "$dst" ]]; then backup "$dst"; fi
  local content
  content=$(<"$src")
  content="${content//@HOME@/$HOME_DIR}"
  printf '%s\n' "$content" > "$dst"
  if [[ -x "$src" ]]; then chmod +x "$dst"; fi
}

echo "Installing Waywallen extras only (dotfiles rice untouched)…"

write_rewritten "$OPT/bin/waywallen-noctalia-palette" "$HOME_DIR/.local/bin/waywallen-noctalia-palette"
chmod +x "$HOME_DIR/.local/bin/waywallen-noctalia-palette"

write_rewritten "$OPT/bin/waywallen-gtk-qt-palette" "$HOME_DIR/.local/bin/waywallen-gtk-qt-palette"
chmod +x "$HOME_DIR/.local/bin/waywallen-gtk-qt-palette"

mkdir -p "$HOME_DIR/.local/lib"
write_rewritten "$OPT/lib/waywallen-gtk-qt-palette-lib.py" "$HOME_DIR/.local/lib/waywallen-gtk-qt-palette-lib.py"
chmod +x "$HOME_DIR/.local/lib/waywallen-gtk-qt-palette-lib.py"

mkdir -p "$HOME_DIR/.config/waywallen"
write_rewritten "$OPT/config/gtk-qt-palette-templates.toml" \
  "$HOME_DIR/.config/waywallen/gtk-qt-palette-templates.toml"

mkdir -p "$HOME_DIR/.config/systemd/user"
for u in waywallen-noctalia-palette.path \
         waywallen-noctalia-palette.service \
         waywallen-noctalia-palette.timer; do
  write_rewritten "$OPT/systemd/$u" "$HOME_DIR/.config/systemd/user/$u"
done

mkdir -p "$HOME_DIR/.config/autostart" "$HOME_DIR/.config/waywallen" "$HOME_DIR/Applications"
write_rewritten "$OPT/autostart/waywallen.desktop.template" \
  "$HOME_DIR/.config/autostart/waywallen.desktop"
write_rewritten "$OPT/docs/noctalia-palette-bridge.md" \
  "$HOME_DIR/.config/waywallen/noctalia-palette-bridge.md"

if command -v systemctl >/dev/null 2>&1; then
  systemctl --user daemon-reload || true
  systemctl --user enable --now waywallen-noctalia-palette.path \
    waywallen-noctalia-palette.timer 2>/dev/null \
    || echo "Could not enable user units yet — run after a graphical login."
fi

echo
echo "Waywallen extras installed (rice configs not modified)."
echo "  • GTK/Qt/KDE wallpaper palette is part of this optional path only."
echo "  • First wallpaper change generates MaterialYouDark + GTK + qt5ct — no hand-crafting."
echo "  • AppImage → $HOME_DIR/Applications/waywallen.appimage"
echo "  • Autostart → $HOME_DIR/.config/autostart/waywallen.desktop"
echo "  • Turn Noctalia wallpaper drawing OFF while Waywallen owns the desktop."
echo "  • Rollback anytime: $OPT/uninstall.sh"
if [[ ! -x "$HOME_DIR/Applications/waywallen.appimage" ]]; then
  echo "  • AppImage not found yet — put it in ~/Applications when ready."
fi
