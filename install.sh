#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME is not set}"
STAMP="$(date +%Y%m%d-%H%M%S)"
MODE="${DOTFILES_MODE:-}"

if [[ -z "$MODE" ]]; then
  read -r -p 'Profile (1=full with Noctalia / 2=tech): ' MODE
fi
if [[ "$MODE" == 1 || "$MODE" == full ]]; then
  MODE=full
else
  MODE=tech
fi

backup() {
  local f="$1"
  if [[ -e "$f" && ! -L "$f" ]]; then
    mv -- "$f" "$f.bak.$STAMP"
  fi
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
    mkdir -p "$(dirname -- "$dst")"
    backup "$dst"
    content=$(<"$src")
    content="${content//@HOME@/$HOME_DIR}"
    printf '%s\n' "$content" > "$dst"
    if [[ -x "$src" ]]; then chmod +x "$dst"; fi
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

echo
echo "Done ($MODE). Backups use suffix .bak.$STAMP"
echo "Next: configure monitors (see README) and restart niri / relog."
