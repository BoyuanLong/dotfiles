# Initialize completion
autoload -Uz compinit && compinit -i
zstyle ':completion:*' menu select=4
zmodload zsh/complist
# Use vim style navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Initialize editing command line
autoload -U edit-command-line && zle -N edit-command-line

# Enable interactive comments (# on the command line)
setopt interactivecomments

# Nicer history
HISTSIZE=1048576
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt incappendhistory
setopt extendedhistory

# Time to wait for additional characters in a sequence
KEYTIMEOUT=1 # corresponds to 10ms

# Use vim as the editor
export EDITOR=vim

# Use vim style line editing in zsh
bindkey -v
# Movement
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'G' end-of-buffer-or-history
# Undo
bindkey -a 'u' undo
bindkey -a '^R' redo
# Edit line
bindkey -a '^V' edit-command-line
# Backspace
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# Use incremental search
bindkey "^R" history-incremental-search-backward

# Disable shell builtins
disable r

# Prevent less from keeping history file
export LESSHISTFILE=/dev/null

# fzf configuration
if command -v fzf &>/dev/null; then
    # Use fd for fzf if available (faster, respects .gitignore)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # Solarized dark color scheme
    export FZF_DEFAULT_OPTS='
        --color=bg+:#073642,bg:#002b36,spinner:#719e07,hl:#586e75
        --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#719e07
        --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07
        --bind=ctrl-d:half-page-down,ctrl-u:half-page-up'

    # Source fzf keybindings and completion (supports multiple install methods)
    if [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        source /usr/share/doc/fzf/examples/completion.zsh
    elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
        source /usr/local/opt/fzf/shell/key-bindings.zsh
        source /usr/local/opt/fzf/shell/completion.zsh
    fi
fi
