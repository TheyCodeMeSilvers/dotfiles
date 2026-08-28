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
  log "Using repo at $REPO_ROOT"
  log "Backups will be stored in $BACKUP_ROOT if anything is replaced"

  ensure_link "$REPO_ROOT/configs/ghostty" "$HOME_DIR/.config/ghostty"
  ensure_link "$REPO_ROOT/configs/nvim" "$HOME_DIR/.config/nvim"
  ensure_link "$REPO_ROOT/configs/hammerspoon" "$HOME_DIR/.hammerspoon"

  log "Bootstrap complete"
  log "Restart Ghostty, Hammerspoon, and Neovim to pick up changes"
}

main
