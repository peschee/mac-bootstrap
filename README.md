# mac-bootstrap 🙂

```
                           __                __       __
   ____ ___  ____ ______  / /_  ____  ____  / /______/ /__________ _____
  / __ `__ \/ __ `/ ___/ / __ \/ __ \/ __ \/ __/ ___/ __/ ___/ __ `/ __ \
 / / / / / / /_/ / /__  / /_/ / /_/ / /_/ / /_(__  ) /_/ /  / /_/ / /_/ /
/_/ /_/ /_/\__,_/\___/ /_.___/\____/\____/\__/____/\__/_/   \__,_/ .___/
                                                                 /_/
```

`🍎 + 🍺 + 🐚 = ready`

Minimal macOS setup for this machine: Homebrew packages + shell config + optional local secrets.

## What's included

- `Brewfile`: installed Homebrew formulas/casks to recreate this setup.
- `shell/.zshrc`: base zsh setup (brew, mise, starship, fzf, fnm, zoxide, zsh-autosuggestions, zsh-syntax-highlighting, completions).
- `shell/aliases.sh`: shared aliases for zsh/bash.
- `~/.zshrc.local` or `~/.bashrc.local`: optional local-only secrets/settings (not committed).

## Setup on a new Mac

```bash
git clone <your-repo-url> ~/mac-bootstrap
cd ~/mac-bootstrap
./scripts/bootstrap.sh
```

Dry run (no changes): `./scripts/bootstrap.sh --dry-run`

## Java versions (mise)

Bootstrap configures Java via `mise` with pinned Temurin LTS versions:

- `temurin-11`
- `temurin-17`
- `temurin-21` (global default)

Useful commands:

```bash
mise list java
mise current java
java -version
```

For a specific project, pin one of the installed versions in that repo:

```bash
mise use java@temurin-17
```

## Update Brewfile

After installing/removing apps locally, refresh the repo Brewfile:

```bash
./scripts/update-brewfile.sh
```
