# AGENTS.md

Agent guidance for this `mac-bootstrap` repo.

## Project overview

- Purpose: reproducible macOS shell/bootstrap setup using Homebrew + dotfile symlinks.
- Keep this repo declarative: committed files define the desired machine state.

## Setup commands

- Full bootstrap: `./scripts/bootstrap.sh`
- Dry run: `./scripts/bootstrap.sh --dry-run`
- Re-link dotfiles only: `./scripts/symlink.sh`
- Dry-run symlinks: `./scripts/symlink.sh --dry-run`

## Source-of-truth rules

- Add/remove Homebrew apps in `Brewfile` (do not add one-off installs in `scripts/bootstrap.sh`).
- Put shared aliases in `shell/aliases.sh`.
- Put shared shell initialization (tool init/env) in `shell/.zshrc`.
- Keep machine-specific or secret values in `~/.zshrc.local` (generated from `shell/local.sh.example` if missing).
- `scripts/bootstrap.sh` should orchestrate setup steps, not become the place for per-tool custom config.

## Shell conventions

- `shell/.zshrc` is symlinked to `~/.zshrc` by `scripts/symlink.sh`.
- `shell/aliases.sh` is symlinked to `~/.aliases.sh` and sourced from `shell/.zshrc`.
- Prefer idempotent config changes (safe to re-run bootstrap multiple times).
- For navigation helpers, use `zoxide` init in `shell/.zshrc`; aliases like `j` belong in `shell/aliases.sh`.

## Updating dependencies

- After local package changes, refresh and commit the lock-in list:
  - `brew bundle dump --describe --force --file ~/mac-bootstrap/Brewfile`
- Keep comments in `Brewfile` concise and meaningful.

## Validation checklist

- Run `./scripts/bootstrap.sh --dry-run` to verify intended actions.
- Run `./scripts/symlink.sh --dry-run` if changing link behavior.
- Ensure shell files remain sourceable (no syntax errors in edited shell scripts).

## Change hygiene

- Make minimal, focused edits.
- Preserve existing style and script patterns (`set -euo pipefail`, helper functions, dry-run behavior).
- Do not commit machine-specific paths, secrets, or local-only overrides.
