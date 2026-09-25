#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME is not set}"
STAMP="$(date +%Y%m%d-%H%M%S)"
MODE="${DOTFILES_MODE:-}"
WANT_WAYWALLEN="${INSTALL_WAYWALLEN:-}"

if [[ -z "$MODE" ]]; then
  read -r -p 'Profile (1=full with Noctalia / 2=tech): ' MODE
fi
if [[ "$MODE" == 1 || "$MODE" == full ]]; then
  MODE=full
else
  MODE=tech
fi

# Waywallen is optional: AppImage is NOT shipped; we only install bridge + autostart template + units.
if [[ -z "$WANT_WAYWALLEN" ]]; then
  if [[ "$MODE" == full ]]; then
    read -r -p 'Optional Waywallen extras (palette bridge + autostart template)? [y/N]: ' WANT_WAYWALLEN
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
  mkdir -p "$(dirname -- "$dst")"
  backup "$dst"
  local content
  content=$(<"$src")
  content="${content//@HOME@/$HOME_DIR}"
  printf '%s\n' "$content" > "$dst"
  if [[ -x "$src" ]]; then chmod +x "$dst"; fi
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

install_tree "$ROOT/.config"
install_tree "$ROOT/.local"

if [[ "$MODE" == tech ]]; then
  backup "$HOME_DIR/.config/niri/config.kdl"
  sed "s|@HOME@|$HOME_DIR|g" "$ROOT/.config/niri/config-no-noctalia.kdl" > "$HOME_DIR/.config/niri/config.kdl"
fi

mkdir -p "$HOME_DIR/.config/niri/cfg"
cp -f "$ROOT/.config/niri/cfg/outputs.kdl.example" "$HOME_DIR/.config/niri/cfg/outputs.kdl.example"

if [[ "$WANT_WAYWALLEN" == 1 ]]; then
  if [[ "$MODE" != full ]]; then
    echo "Note: Waywallen palette bridge expects Noctalia (full profile)."
  fi
  bash "$ROOT/optional/waywallen/install.sh"
fi

echo
echo "Done (profile=$MODE, waywallen=$WANT_WAYWALLEN). Backups use suffix .bak.$STAMP"
echo "Next: configure monitors (see README) and restart niri / relog."
if [[ "$WANT_WAYWALLEN" == 1 ]]; then
  echo "Waywallen: see optional/waywallen/README.md"
fi
