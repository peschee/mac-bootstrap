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

backup_if_needed() {
  local target_path="$1"
  local source_path="$2"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    return
  fi

  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    local backup_path="${target_path}.pre-mac-bootstrap.bak"
    if [ -e "$backup_path" ]; then
      echo "Backup already exists, leaving current file in place: $backup_path"
      return 1
    fi
    run_cmd mv "$target_path" "$backup_path"
    echo "Backed up existing file: $target_path -> $backup_path"
  fi

  return 0
}

link_file() {
  local source_path="$1"
  local target_path="$2"

  if ! backup_if_needed "$target_path" "$source_path"; then
    echo "Skipped linking to avoid overwriting existing file: $target_path"
    return
  fi

  run_cmd ln -sfn "$source_path" "$target_path"
}

link_file "$REPO_ROOT/shell/.zshrc" "$HOME/.zshrc"
link_file "$REPO_ROOT/shell/.bashrc" "$HOME/.bashrc"
link_file "$REPO_ROOT/shell/aliases.sh" "$HOME/.aliases.sh"

echo "Symlinked shell files from $REPO_ROOT"
