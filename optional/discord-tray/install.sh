#!/usr/bin/env bash
# Install ONLY Discord tray wrapper + desktop/autostart overrides.
# Does not copy or overwrite Niri/Noctalia/Kitty rice files.
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

echo "Installing Discord tray extras only (dotfiles rice untouched)…"

mkdir -p "$HOME_DIR/.local/bin"
write_rewritten "$OPT/bin/discord-tray" "$HOME_DIR/.local/bin/discord-tray"
chmod +x "$HOME_DIR/.local/bin/discord-tray"

mkdir -p "$HOME_DIR/.local/share/applications"
write_rewritten "$OPT/applications/discord.desktop.template" \
  "$HOME_DIR/.local/share/applications/discord.desktop"

mkdir -p "$HOME_DIR/.config/autostart"
write_rewritten "$OPT/autostart/discord.desktop.template" \
  "$HOME_DIR/.config/autostart/discord.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME_DIR/.local/share/applications" 2>/dev/null || true
fi

echo
echo "Discord tray extras installed (rice configs not modified)."
echo "  • Wrapper → $HOME_DIR/.local/bin/discord-tray"
echo "  • App menu → $HOME_DIR/.local/share/applications/discord.desktop"
echo "  • Autostart → $HOME_DIR/.config/autostart/discord.desktop"
echo "  • Restart Discord via the wrapper (quit old instance first)."
echo "  • Middle-click notes → $OPT/docs/middle-click-autoscroll.md"
echo "  • Rollback anytime: $OPT/uninstall.sh"
