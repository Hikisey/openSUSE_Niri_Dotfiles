#!/usr/bin/env bash
# Remove Discord tray extras installed by optional/discord-tray/install.sh.
# Does not touch Niri/Noctalia rice configs or Discord itself.
set -euo pipefail
HOME_DIR="${HOME:?HOME is not set}"

rm -f "$HOME_DIR/.local/bin/discord-tray"
rm -f "$HOME_DIR/.local/share/applications/discord.desktop"
rm -f "$HOME_DIR/.config/autostart/discord.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME_DIR/.local/share/applications" 2>/dev/null || true
fi

echo "Discord tray extras removed."
echo "  Stock /usr/share/applications/discord.desktop will apply again for launches."
echo "  Quit any running Discord started via the wrapper if it is still open."
