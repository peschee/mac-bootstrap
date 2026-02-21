#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required. Installing..."
  xcode-select --install || true
  echo "Complete the installer, then re-run this script."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing apps and tools from Brewfile..."
brew bundle --file "$REPO_ROOT/Brewfile"

echo "Creating shell symlinks..."
"$REPO_ROOT/scripts/symlink.sh"

if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$REPO_ROOT/shell/local.sh.example" "$HOME/.zshrc.local"
  echo "Created ~/.zshrc.local from template."
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
