# mise (version manager — sets PATH, JAVA_HOME, etc.)
eval "$(mise activate bash)"
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -f "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh"
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
