#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
  printf '[dotfiles] %s\n' "$*"
}

ensure_rust_tooling() {
  if ! command -v rustup >/dev/null 2>&1; then
    if [[ -x "$HOME/.cargo/bin/rustup" ]]; then
      export PATH="$HOME/.cargo/bin:$PATH"
    else
      log "Installing rustup for Neovim Rust support"
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable
      export PATH="$HOME/.cargo/bin:$PATH"
    fi
  fi

  if ! command -v rustup >/dev/null 2>&1; then
    log "rustup is required but was not installed successfully"
    exit 1
  fi

  log "Ensuring Rust stable toolchain and editor components"
  rustup toolchain install stable --profile minimal
  rustup component add --toolchain stable rust-analyzer rustfmt clippy
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  log "Homebrew not found. Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

main() {
  install_homebrew
  ensure_rust_tooling

  log "Installing apps and tools from Brewfile"
  brew bundle --file "$REPO_ROOT/Brewfile"

  log "Running bootstrap"
  "$REPO_ROOT/scripts/bootstrap.sh"
}

main
