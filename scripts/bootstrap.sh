#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DRY_RUN=0
NUKE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --nuke)       NUKE=1 ;;
    *)
      echo "Usage: $0 [--dry-run] [--nuke]"
      exit 2
      ;;
  esac
done

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

nuke_homebrew() {
  if ! command -v brew >/dev/null 2>&1 \
     && [ ! -d /opt/homebrew ] \
     && [ ! -d /usr/local/Homebrew ]; then
    echo "Homebrew is not installed. Skipping nuke, continuing with bootstrap."
    return
  fi

  echo ""
  echo "WARNING: --nuke will DESTROY your Homebrew installation."
  echo "This removes ALL formulae, casks, and Homebrew itself."
  echo "The bootstrap will then reinstall everything from scratch."
  echo ""

  if [ "$DRY_RUN" -eq 1 ]; then
    echo '[dry-run] /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"'
    return
  fi

  printf "Type YES to confirm: "
  read -r confirmation
  if [ "$confirmation" != "YES" ]; then
    echo "Aborted."
    exit 1
  fi

  echo "Removing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  hash -r 2>/dev/null || true
  echo ""
  echo "Homebrew removed. Continuing with fresh bootstrap..."
  echo ""
}

if [ "$NUKE" -eq 1 ]; then
  nuke_homebrew
fi

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

echo "Configuring Java versions with mise..."
if [ "$DRY_RUN" -eq 1 ]; then
  run_cmd "$REPO_ROOT/scripts/mise-java-setup.sh" --dry-run
else
  run_cmd "$REPO_ROOT/scripts/mise-java-setup.sh"
fi

echo "Creating shell symlinks..."
if [ "$DRY_RUN" -eq 1 ]; then
  run_cmd "$REPO_ROOT/scripts/symlink.sh" --dry-run
else
  run_cmd "$REPO_ROOT/scripts/symlink.sh"
fi

echo "Starting Tailscale..."
if [ -d "/Applications/Tailscale.app" ]; then
  if ! pgrep -q Tailscale; then
    run_cmd open -a Tailscale
    echo "Tailscale launched — sign in from the menu bar icon."
  else
    echo "Tailscale is already running."
  fi
else
  echo "Tailscale.app not found — skipping (install via Brewfile)."
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
