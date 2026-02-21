eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# asdf (version manager)
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
  . /usr/local/opt/asdf/libexec/asdf.sh
fi

# asdf-java JAVA_HOME integration
[ -f "$HOME/.asdf/plugins/java/set-java-home.zsh" ] && source "$HOME/.asdf/plugins/java/set-java-home.zsh"

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
