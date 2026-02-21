#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=0
if [ "${1:-}" = "--dry-run" ] || [ "${1:-}" = "-n" ]; then
  DRY_RUN=1
elif [ "${1:-}" != "" ]; then
  echo "Usage: $0 [--dry-run]"
  exit 2
fi

JAVA_11="temurin-11"
JAVA_17="temurin-17"
JAVA_21="temurin-21"

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

find_mise_bin() {
  if command -v mise >/dev/null 2>&1; then
    command -v mise
    return
  fi

  if [ -x /opt/homebrew/bin/mise ]; then
    echo /opt/homebrew/bin/mise
    return
  fi

  if [ -x /usr/local/bin/mise ]; then
    echo /usr/local/bin/mise
    return
  fi

  echo ""
}

MISE_BIN="$(find_mise_bin)"
if [ -z "$MISE_BIN" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] mise not found in PATH yet."
    echo "[dry-run] Would run: mise install java@$JAVA_11"
    echo "[dry-run] Would run: mise install java@$JAVA_17"
    echo "[dry-run] Would run: mise install java@$JAVA_21"
    echo "[dry-run] Would run: mise use -g java@$JAVA_21"
    exit 0
  fi

  echo "mise is required but was not found."
  echo "Re-run bootstrap (it installs mise from Brewfile) and try again."
  exit 1
fi

run_cmd "$MISE_BIN" install "java@$JAVA_11"
run_cmd "$MISE_BIN" install "java@$JAVA_17"
run_cmd "$MISE_BIN" install "java@$JAVA_21"
run_cmd "$MISE_BIN" use -g "java@$JAVA_21"

echo "mise Java setup complete."
