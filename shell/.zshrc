eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# mise (version manager — sets PATH, JAVA_HOME, etc.)
eval "$(mise activate zsh)"

# Initialize Starship prompt
eval "$(starship init zsh)"

# fzf key bindings & completion
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# enable extended completion
autoload -Uz compinit && compinit

# https://github.com/Schniz/fnm#shell-setup
eval "$(fnm env --use-on-cd --shell zsh)"

# zoxide
eval "$(zoxide init zsh)"

# additional completions
fpath+=("/opt/homebrew/share/zsh-completions")

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

[ -f "$HOME/.aliases.sh" ] && source "$HOME/.aliases.sh"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
