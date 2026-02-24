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

# System update
alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup"
