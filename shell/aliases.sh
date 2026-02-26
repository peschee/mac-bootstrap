# Shared aliases for zsh and bash.

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias j="z"

# macOS/BSD ls with colors
alias l="ls -AlFh -G"

# Re-source zsh config
alias resource="source ~/.zshrc"

# System update — 'update' checks for updates, 'upgrade' applies them
alias update="sudo softwareupdate -i -a; brew update; brew outdated"
alias upgrade="brew upgrade && brew cleanup"

# List all listening TCP ports (requires sudo for full visibility)
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P"

# Git-run log across repos — usage: grlog 30 (default: 14 days)
grlog() {
  npx git-run git --no-pager log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=short --perl-regexp --author="siska|peschee" --since="${1:-14}.days"
}
