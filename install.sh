#!/usr/bin/env bash
# Safe by default: never overwrite existing user configs.
# FORCE=1 restores old behavior (backup + replace).
#
# Theme policy (fresh openSUSE + stock Plasma):
#   - Default path does NOT install wallpaper-driven GTK/Qt/KDE colors.
#   - Stock Breeze / BreezeClassic (Plasma) and Noctalia builtin stay until
#     the user changes a wallpaper (Noctalia) or enables optional Waywallen.
#   - GTK-Qt palette bridge is installed ONLY via optional/waywallen/.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME is not set}"
STAMP="$(date +%Y%m%d-%H%M%S)"
MODE="${DOTFILES_MODE:-}"
WANT_WAYWALLEN="${INSTALL_WAYWALLEN:-}"
FORCE="${FORCE:-0}"
SKIPPED=0
WRITTEN=0

if [[ -z "$MODE" ]]; then
  read -r -p 'Profile (1=full with Noctalia / 2=tech): ' MODE
fi
if [[ "$MODE" == 1 || "$MODE" == full ]]; then
  MODE=full
else
  MODE=tech
fi

if [[ -z "$WANT_WAYWALLEN" ]]; then
  if [[ "$MODE" == full ]]; then
    echo
    echo "Theme note: without Waywallen you keep Noctalia’s builtin look and"
    echo "stock Plasma (Breeze / BreezeClassic) for GTK/Qt. No hand-crafted"
    echo "MaterialYouDark required. Waywallen (optional) derives Noctalia+GTK+Qt"
    echo "from the active wallpaper on first change."
    read -r -p 'Optional Waywallen extras (wallpaper→Noctalia+GTK+Qt palette + autostart)? [y/N]: ' WANT_WAYWALLEN
  else
    WANT_WAYWALLEN=n
  fi
fi
case "${WANT_WAYWALLEN,,}" in
  y|yes|1|true) WANT_WAYWALLEN=1 ;;
  *) WANT_WAYWALLEN=0 ;;
esac

backup() {
  local f="$1"
  if [[ -e "$f" && ! -L "$f" ]]; then
    mv -- "$f" "$f.bak.$STAMP"
  fi
}

write_rewritten() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && "$FORCE" != 1 ]]; then
    SKIPPED=$((SKIPPED + 1))
    return 0
  fi
  mkdir -p "$(dirname -- "$dst")"
  if [[ -e "$dst" ]]; then
    backup "$dst"
  fi
  local content
  content=$(<"$src")
  content="${content//@HOME@/$HOME_DIR}"
  printf '%s\n' "$content" > "$dst"
  if [[ -x "$src" ]]; then chmod +x "$dst"; fi
  WRITTEN=$((WRITTEN + 1))
}

if [[ "${SKIP_PACKAGES:-0}" != 1 ]] && command -v zypper >/dev/null 2>&1; then
  mapfile -t pkgs < <(grep -Ev '^(#|$)' "$ROOT/packages/zypper.txt" || true)
  if ((${#pkgs[@]})); then
    echo "Installing suggested packages (may ask sudo)…"
    sudo zypper in -y "${pkgs[@]}" || echo "zypper step skipped/failed — continuing."
  fi
fi

install_tree() {
  local src_root="$1"
  [[ -d "$src_root" ]] || return 0
  while IFS= read -r -d '' src; do
    rel="${src#"$ROOT"/}"
    if [[ "$MODE" == tech ]]; then
      case "$rel" in
        .config/niri/noctalia.kdl|.config/noctalia/*) continue ;;
      esac
    fi
    dst="$HOME_DIR/$rel"
    write_rewritten "$src" "$dst"
  done < <(find "$src_root" -type f -print0)
}

echo "Mode: $MODE (FORCE=$FORCE — existing files are $([ "$FORCE" = 1 ] && echo 'backed up + replaced' || echo 'left alone'))"

# Rice only: .config + .local. Never ships kdeglobals / GTK / qt5ct / MaterialYouDark.
install_tree "$ROOT/.config"
install_tree "$ROOT/.local"

if [[ "$MODE" == tech ]]; then
  if [[ ! -e "$HOME_DIR/.config/niri/config.kdl" || "$FORCE" == 1 ]]; then
    write_rewritten "$ROOT/.config/niri/config-no-noctalia.kdl" "$HOME_DIR/.config/niri/config.kdl"
  else
    SKIPPED=$((SKIPPED + 1))
  fi
fi

mkdir -p "$HOME_DIR/.config/niri/cfg"
# example file is safe to refresh — it is not the live outputs config
cp -f "$ROOT/.config/niri/cfg/outputs.kdl.example" "$HOME_DIR/.config/niri/cfg/outputs.kdl.example"

# Wallpaper → GTK/Qt/KDE bridge ONLY with optional Waywallen path (never by default).
if [[ "$WANT_WAYWALLEN" == 1 ]]; then
  if [[ "$MODE" != full ]]; then
    echo "Note: Waywallen palette bridge expects Noctalia (full profile)."
  fi
  FORCE="$FORCE" bash "$ROOT/optional/waywallen/install.sh"
fi

echo
echo "Done (profile=$MODE, waywallen=$WANT_WAYWALLEN). wrote=$WRITTEN skipped_existing=$SKIPPED"
if [[ "$FORCE" != 1 && "$SKIPPED" -gt 0 ]]; then
  echo "Existing configs were kept. To replace with rice defaults: FORCE=1 ./install.sh"
fi
echo "Next: configure monitors (see README) and restart niri / relog."
echo
if [[ "$WANT_WAYWALLEN" == 1 ]]; then
  echo "Theme: Waywallen extras enabled — first wallpaper change generates"
  echo "  Noctalia + GTK + Qt palette (no manual MaterialYouDark). See:"
  echo "  optional/waywallen/README.md"
else
  echo "Theme (default, no Waywallen):"
  echo "  • Noctalia: builtin / soft until you set a wallpaper in Noctalia"
  echo "  • GTK/Qt/KDE: stock Plasma (Breeze / BreezeClassic) — unchanged"
  echo "  • Optional later: ./optional/waywallen/install.sh for wallpaper-driven colors"
fi
