#!/bin/bash
set -euo pipefail

BREWFILE_PATH="$(dirname "$0")/../Brewfile"

echo "Updating Brewfile at $BREWFILE_PATH..."
brew bundle dump --describe --force --file "$BREWFILE_PATH"

echo "Brewfile updated successfully."
