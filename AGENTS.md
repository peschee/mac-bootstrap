# CLAUDE.md

Agent guidance for this `mac-bootstrap` repo.

## Project overview

- Purpose: reproducible macOS shell/bootstrap setup using Homebrew + dotfile symlinks.
- Keep this repo declarative: committed files define the desired machine state.

## Directory structure

```
├── Brewfile                  # Homebrew package manifest
├── scripts/
│   ├── bootstrap.sh          # Main setup orchestrator
│   ├── symlink.sh            # Dotfile symlink creator
│   ├── mise-java-setup.sh    # Java versions via mise
│   └── update-brewfile.sh    # Refresh Brewfile from installed packages
└── shell/
    ├── .zshrc                # Main zsh config (symlinked to ~/.zshrc)
    ├── .bashrc               # Minimal bash config (symlinked to ~/.bashrc)
    ├── .gitconfig             # Shared git config (symlinked to ~/.gitconfig)
    ├── .gitignore_global      # Global gitignore (symlinked to ~/.gitignore_global)
    ├── aliases.sh            # Shared aliases (symlinked to ~/.aliases.sh)
    ├── starship.toml         # Starship prompt config (symlinked to ~/.config/starship.toml)
    ├── .vimrc                # Vim config (symlinked to ~/.vimrc)
    ├── .gemrc                # Gem config — disables doc installs (symlinked to ~/.gemrc)
    └── local.sh.example      # Template for ~/.zshrc.local secrets
```

## Setup commands

- Full bootstrap: `./scripts/bootstrap.sh`
- Dry run: `./scripts/bootstrap.sh --dry-run`
- Nuke & rebuild: `./scripts/bootstrap.sh --nuke`
- Nuke dry run: `./scripts/bootstrap.sh --nuke --dry-run`
- Re-link dotfiles only: `./scripts/symlink.sh`
- Dry-run symlinks: `./scripts/symlink.sh --dry-run`

## Source-of-truth rules

- Add/remove Homebrew apps in `Brewfile` (do not add one-off installs in `scripts/bootstrap.sh`).
- Put shared aliases in `shell/aliases.sh`.
- Put shared shell initialization (tool init/env) in `shell/.zshrc`.
- Keep machine-specific or secret values in `~/.zshrc.local` (generated from `shell/local.sh.example` if missing).
- `scripts/bootstrap.sh` should orchestrate setup steps, not become the place for per-tool custom config.

## Script patterns

- `scripts/mise-java-setup.sh` has two dry-run paths that must stay in sync: a manual `echo` fallback (when mise binary isn't found yet) and the `run_cmd` wrapper (normal path). When adding commands, update both blocks.

## Shell conventions

- `shell/.zshrc` is symlinked to `~/.zshrc` by `scripts/symlink.sh`.
- `shell/.bashrc` is symlinked to `~/.bashrc`.
- `shell/.gitconfig` is symlinked to `~/.gitconfig`.
- `shell/.gitignore_global` is symlinked to `~/.gitignore_global` (referenced by `.gitconfig` `core.excludesFile`).
- `shell/aliases.sh` is symlinked to `~/.aliases.sh` and sourced from `shell/.zshrc`.
- `shell/starship.toml` is symlinked to `~/.config/starship.toml` (Starship prompt config).
- `shell/.vimrc` is symlinked to `~/.vimrc`.
- `shell/.gemrc` is symlinked to `~/.gemrc`.
- Prefer idempotent config changes (safe to re-run bootstrap multiple times).
- For navigation helpers, use `zoxide` init in `shell/.zshrc`; aliases like `j` belong in `shell/aliases.sh`.
- Key tools initialized in `.zshrc`: mise (version manager), fnm (Node.js), Starship (prompt), fzf, zoxide.

## Updating dependencies

- After local package changes, refresh and commit the lock-in list:
  - `./scripts/update-brewfile.sh` (or manually: `brew bundle dump --describe --force --file ~/mac-bootstrap/Brewfile`)
- Keep comments in `Brewfile` concise and meaningful.

## Validation checklist

- Run `./scripts/bootstrap.sh --dry-run` to verify intended actions.
- Run `./scripts/symlink.sh --dry-run` if changing link behavior.
- Ensure shell files remain sourceable (no syntax errors in edited shell scripts).

## Change hygiene

- Make minimal, focused edits.
- Preserve existing style and script patterns (`set -euo pipefail`, helper functions, dry-run behavior).
- Do not commit machine-specific paths, secrets, or local-only overrides.
