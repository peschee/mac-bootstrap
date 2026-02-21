#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=0
if [ "${1:-}" = "--dry-run" ] || [ "${1:-}" = "-n" ]; then
  DRY_RUN=1
elif [ "${1:-}" != "" ]; then
  echo "Usage: $0 [--dry-run]"
  exit 2
fi

JAVA_11="temurin-11.0.30+7"
JAVA_17="temurin-17.0.18+8"
JAVA_21="temurin-21.0.10+7.0.LTS"

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

find_asdf_bin() {
  if command -v asdf >/dev/null 2>&1; then
    command -v asdf
    return
  fi

  if [ -x /opt/homebrew/bin/asdf ]; then
    echo /opt/homebrew/bin/asdf
    return
  fi

  if [ -x /usr/local/bin/asdf ]; then
    echo /usr/local/bin/asdf
    return
  fi

  echo ""
}

ASDF_BIN="$(find_asdf_bin)"
if [ -z "$ASDF_BIN" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] asdf not found in PATH yet."
    echo "[dry-run] Would run: asdf plugin add java https://github.com/halcyon/asdf-java.git"
    echo "[dry-run] Would run: asdf install java $JAVA_11"
    echo "[dry-run] Would run: asdf install java $JAVA_17"
    echo "[dry-run] Would run: asdf install java $JAVA_21"
    echo "[dry-run] Would run: asdf set -u java $JAVA_21 $JAVA_17 $JAVA_11"
    exit 0
  fi

  echo "asdf is required but was not found."
  echo "Re-run bootstrap (it installs asdf from Brewfile) and try again."
  exit 1
fi

PLUGIN_LIST="$($ASDF_BIN plugin list 2>/dev/null || true)"
case $'\n'"$PLUGIN_LIST"$'\n' in
  *$'\njava\n'*) ;;
  *) run_cmd "$ASDF_BIN" plugin add java https://github.com/halcyon/asdf-java.git ;;
esac

run_cmd "$ASDF_BIN" install java "$JAVA_11"
run_cmd "$ASDF_BIN" install java "$JAVA_17"
run_cmd "$ASDF_BIN" install java "$JAVA_21"
run_cmd "$ASDF_BIN" set -u java "$JAVA_21" "$JAVA_17" "$JAVA_11"
run_cmd "$ASDF_BIN" reshim java

echo "asdf Java setup complete."
