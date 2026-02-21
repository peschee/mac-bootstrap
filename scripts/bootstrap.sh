#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DRY_RUN=0
if [ "${1:-}" = "--dry-run" ] || [ "${1:-}" = "-n" ]; then
  DRY_RUN=1
elif [ "${1:-}" != "" ]; then
  echo "Usage: $0 [--dry-run]"
  exit 2
fi

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

find_brew_bin() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    echo /opt/homebrew/bin/brew
    return
  fi

  if [ -x /usr/local/bin/brew ]; then
    echo /usr/local/bin/brew
    return
  fi

  echo ""
}

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required. Installing..."
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] xcode-select --install"
    echo "Dry run stops here because a real run would require manual installation first."
    exit 0
  else
    xcode-select --install || true
    echo "Complete the installer, then re-run this script."
    exit 1
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

BREW_BIN="$(find_brew_bin)"
if [ -z "$BREW_BIN" ]; then
  echo "Could not find brew after install step."
  exit 1
fi

eval "$($BREW_BIN shellenv)"

echo "Installing apps and tools from Brewfile..."
run_cmd "$BREW_BIN" bundle --file "$REPO_ROOT/Brewfile"

echo "Creating shell symlinks..."
if [ "$DRY_RUN" -eq 1 ]; then
  run_cmd "$REPO_ROOT/scripts/symlink.sh" --dry-run
else
  run_cmd "$REPO_ROOT/scripts/symlink.sh"
fi

if [ ! -f "$HOME/.zshrc.local" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] Would create ~/.zshrc.local from template."
  else
    run_cmd cp "$REPO_ROOT/shell/local.sh.example" "$HOME/.zshrc.local"
    echo "Created ~/.zshrc.local from template."
  fi
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
