# Dotfiles Setup

This repo is the source of truth for the local config of:

- Ghostty
- Neovim
- Hammerspoon
- Zen

This repo is designed to behave like your old standalone Neovim config repo, but for multiple apps in one place.

The repo contains the real config files. Your machine's normal config paths are symlinked to those files and directories.

## Install Everything With Homebrew

On a fresh Mac, run:

```bash
./scripts/install.sh
```

That script:

- installs Homebrew if it is missing
- installs `rustup` if it is missing and ensures the stable Rust toolchain editor components are available
- installs `neovim`, `ghostty`, `hammerspoon`, and `zen` from `Brewfile`
- launches Zen once so it creates a profile
- runs `./scripts/bootstrap.sh`

## How it works

Run:

```bash
./scripts/install.sh
```

or, if the apps are already installed:

```bash
./scripts/bootstrap.sh
```

The bootstrap script:

- finds your active Zen profile
- backs up any existing local config it is about to replace
- creates symlinks from the normal config paths to this repo

After that, your normal edit locations are repo-backed.

For example:

- `~/.config/nvim` points to `~/dotfiles/configs/nvim`
- `~/.config/ghostty` points to `~/dotfiles/configs/ghostty`

That means the normal workflow is now:

1. Change config on your current machine.
2. Git sees those edits in this repo immediately.
3. Commit and push the repo.
4. On another machine, pull the repo.
5. Run `./scripts/install.sh`.

## What gets synced

The bootstrap script links these locations:

- `configs/ghostty` -> `~/.config/ghostty`
- `configs/nvim` -> `~/.config/nvim`
- `configs/hammerspoon` -> `~/.hammerspoon`
- `configs/zen/profile/zen-keyboard-shortcuts.json` -> Zen keyboard shortcuts

For Zen, the script reads `~/Library/Application Support/zen/profiles.ini` and links the repo files into whichever profile is marked as the active/default one.

## Commands

From the repo root:

```bash
./scripts/install.sh
./scripts/bootstrap.sh
```

## Typical workflow

### Make and save changes

```bash
cd ~/dotfiles
git add .
git commit -m "update dotfiles"
git push
```

### Apply changes on another machine

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

## First-time setup on another Mac

1. Clone this repo to `~/dotfiles` or another location.
2. Run `./scripts/install.sh`.
3. Restart the apps.

## Safety and backups

Before `bootstrap` replaces anything, the script creates a backup in:

```bash
~/.dotfiles-backups/<timestamp>/
```

That backup contains the previous local versions of the config so you can restore them manually if needed.

## Important notes

- This is a symlink-based single-repo setup.
- After bootstrap, edit the normal config paths and commit from this repo.
- `install.sh` also prepares the Rust tooling required by the Neovim config, including `rust-analyzer`.
- Zen only syncs the keyboard shortcuts file, so the rest of the browser profile stays machine-local.
- The old per-app git repos are no longer needed once the live paths point here.

## Repo structure

```text
dotfiles/
  configs/
    ghostty/
    hammerspoon/
    nvim/
    zen/
      profile/
        zen-keyboard-shortcuts.json
  scripts/
    install.sh
    bootstrap.sh
  README.md
  SETUP.md
```

## If something changes later

If you add another app config to manage, extend `scripts/bootstrap.sh` and add a new folder under `configs/`.

If Zen changes how it stores profiles, update the profile detection logic in `scripts/bootstrap.sh`.
