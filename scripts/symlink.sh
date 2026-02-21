#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ln -sfn "$REPO_ROOT/shell/.zshrc" "$HOME/.zshrc"
ln -sfn "$REPO_ROOT/shell/.bashrc" "$HOME/.bashrc"
ln -sfn "$REPO_ROOT/shell/aliases.sh" "$HOME/.aliases.sh"

echo "Symlinked shell files from $REPO_ROOT"
