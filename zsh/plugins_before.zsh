# External plugins (initialized before)

# zsh-completions
fpath=(~/.dotfiles/zsh/plugins/zsh-completions/src $fpath)

zstyle ':completion:*' matcher-list '' '+m:{a-zA-Z}={A-Za-z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'

# zsh-autosuggestions
source ~/.dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
# bindkey '^m' autosuggest-accept
# bindkey '^o' autosuggest-execute
