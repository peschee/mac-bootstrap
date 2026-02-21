# mac-bootstrap

Minimal macOS setup for this machine: Homebrew packages + shell config + optional local secrets.

## What's included

- `Brewfile`: installed Homebrew formulas/casks to recreate this setup.
- `shell/.zshrc`: base zsh setup (brew, starship, fzf, fnm, completions).
- `shell/aliases.sh`: shared aliases for zsh/bash.
- `~/.zshrc.local` or `~/.bashrc.local`: optional local-only secrets/settings (not committed).

## Setup on a new Mac

```bash
git clone <your-repo-url> ~/mac-bootstrap
cd ~/mac-bootstrap
chmod +x scripts/*.sh
./scripts/bootstrap.sh
```

## Update Brewfile

After installing/removing apps locally, refresh the repo Brewfile:

```bash
brew bundle dump --describe --force --file ~/mac-bootstrap/Brewfile
```
