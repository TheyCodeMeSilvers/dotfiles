#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="$HOME"
BACKUP_ROOT="$HOME_DIR/.dotfiles-backups/bootstrap-$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[dotfiles] %s\n' "$*"
}

require_tool() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "Missing required tool: $1"
    exit 1
  fi
}

detect_zen_profile_dir() {
  local zen_root profiles_ini rel_path
  zen_root="$HOME_DIR/Library/Application Support/zen"
  profiles_ini="$zen_root/profiles.ini"

  if [[ ! -f "$profiles_ini" ]]; then
    log "Zen profile not found. Open Zen once before running this script, or use ./scripts/install.sh."
    exit 1
  fi

  rel_path="$(python3 - "$profiles_ini" <<'PY'
import configparser
import sys

path = sys.argv[1]
config = configparser.RawConfigParser()
config.read(path)

for section in config.sections():
    if section.startswith("Install") and config.has_option(section, "Default"):
        print(config.get(section, "Default"))
        raise SystemExit(0)

for section in config.sections():
    if config.has_option(section, "Default") and config.get(section, "Default") == "1" and config.has_option(section, "Path"):
        print(config.get(section, "Path"))
        raise SystemExit(0)

for section in config.sections():
    if section.startswith("Profile") and config.has_option(section, "Path"):
        print(config.get(section, "Path"))
        raise SystemExit(0)

raise SystemExit(1)
PY
)"

  if [[ -z "$rel_path" ]]; then
    log "Could not determine Zen profile path."
    exit 1
  fi

  printf '%s/%s\n' "$zen_root" "$rel_path"
}

backup_target() {
  local target="$1"
  local rel backup

  [[ -e "$target" || -L "$target" ]] || return 0

  rel="${target#"$HOME_DIR"/}"
  if [[ "$rel" == "$target" ]]; then
    rel="$(basename "$target")"
  fi
  backup="$BACKUP_ROOT/$rel"

  mkdir -p "$(dirname "$backup")"
  mv "$target" "$backup"
  log "Backed up $target -> $backup"
}

ensure_link() {
  local source="$1"
  local target="$2"
  local parent current

  parent="$(dirname "$target")"
  mkdir -p "$parent"

  if [[ -L "$target" ]]; then
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      log "Link already correct: $target"
      return 0
    fi
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup_target "$target"
  fi

  ln -s "$source" "$target"
  log "Linked $target -> $source"
}

main() {
  local zen_profile
  zen_profile="$(detect_zen_profile_dir)"

  log "Using repo at $REPO_ROOT"
  log "Backups will be stored in $BACKUP_ROOT if anything is replaced"

  ensure_link "$REPO_ROOT/configs/ghostty" "$HOME_DIR/.config/ghostty"
  ensure_link "$REPO_ROOT/configs/nvim" "$HOME_DIR/.config/nvim"
  ensure_link "$REPO_ROOT/configs/hammerspoon" "$HOME_DIR/.hammerspoon"
  ensure_link "$REPO_ROOT/configs/zen/profile/zen-keyboard-shortcuts.json" "$zen_profile/zen-keyboard-shortcuts.json"

  log "Bootstrap complete"
  log "Restart Ghostty, Zen, Hammerspoon, and Neovim to pick up changes"
}

require_tool python3

main
