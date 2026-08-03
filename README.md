# Dotfiles

This repo is the single source-controlled home for:

- Ghostty
- Neovim
- Hammerspoon
- Zen

The live config locations on your machine are symlinked back into this repo, so editing `~/.config/nvim` or `~/.config/ghostty` edits repo-tracked files directly.

## Install On A New Mac

```bash
./scripts/install.sh
```

This installs `neovim`, `ghostty`, `hammerspoon`, and `zen` via Homebrew, ensures the Rust toolchain pieces Neovim expects are present, launches Zen once to create a profile, and then runs the bootstrap step.

## Workflow

1. Clone the repo.
2. Run `./scripts/install.sh` on a new Mac, or `./scripts/bootstrap.sh` if everything is already installed.
3. Edit your normal config paths.
4. Commit and push from this repo.

## Repo layout

- `configs/ghostty` -> `~/.config/ghostty`
- `configs/nvim` -> `~/.config/nvim`
- `configs/hammerspoon` -> `~/.hammerspoon`
- `configs/zen/profile/zen-keyboard-shortcuts.json` -> Zen keyboard shortcuts

## First-time setup on another Mac

1. Install Ghostty, Neovim, Zen, and Hammerspoon.
2. Clone this repo.
3. Run `./scripts/install.sh`.
4. Restart the apps.

## Commands

```bash
./scripts/install.sh
./scripts/bootstrap.sh
```

## Notes

- `bootstrap` backs up anything it replaces into `~/.dotfiles-backups/`.
- `install.sh` installs the required apps with Homebrew using `Brewfile`.
- `install.sh` also ensures `rust-analyzer`, `rustfmt`, and `clippy` are available for the Neovim Rust setup.
- Zen links the keyboard shortcuts file into whichever profile is marked as the current default in `profiles.ini`.
- More detail lives in `SETUP.md`.
