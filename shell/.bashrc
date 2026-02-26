# mise (version manager — sets PATH, JAVA_HOME, etc.)
eval "$(mise activate bash)"
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -f "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh"
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/psiska/.cache/lm-studio/bin"
# End of LM Studio CLI section

