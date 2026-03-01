# Modern CLI tool configuration
# Each tool is conditionally configured - only activates if installed.
# Install all tools with: ~/.dotfiles/install_cli_tools.sh

# --- fzf: Fuzzy finder ---
if command -v fzf &>/dev/null; then
    # Use fd for fzf if available (faster, respects .gitignore)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    elif command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
    fi

    # Solarized Dark color scheme for fzf (matches existing theme)
    export FZF_DEFAULT_OPTS='
        --height 40% --layout=reverse --border
        --color=bg+:#073642,bg:#002b36,spinner:#719e07,hl:#586e75
        --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#719e07
        --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07
    '

    # Load fzf keybindings and completion (Ctrl-T, Ctrl-R, Alt-C)
    if [[ "$(fzf --version | cut -d. -f1-2)" > "0.47" ]] 2>/dev/null; then
        source <(fzf --zsh)
    elif [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
    elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
        [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
        source /usr/local/opt/fzf/shell/key-bindings.zsh
        source /usr/local/opt/fzf/shell/completion.zsh
    fi
fi

# --- bat: cat with syntax highlighting ---
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
    export BAT_THEME="Solarized (Dark)"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v batcat &>/dev/null; then
    # Debian/Ubuntu installs bat as batcat
    alias bat='batcat'
    alias cat='batcat --paging=never'
    alias catp='batcat'
    export BAT_THEME="Solarized (Dark)"
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
fi

# --- eza: modern ls replacement ---
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -la --git --icons'
    alias la='eza -a'
    alias l='eza'
    alias lt='eza --tree --level=2'
    alias lta='eza --tree --level=2 -a'
fi

# --- fd: modern find replacement ---
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    # Debian/Ubuntu installs fd as fdfind
    alias fd='fdfind'
fi

# --- ripgrep: fast grep ---
if command -v rg &>/dev/null; then
    export RIPGREP_CONFIG_PATH="$HOME/.dotfiles/ripgreprc"
fi

# --- zoxide: smart cd ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    # z and zi are now available:
    #   z foo     - jump to best match for "foo"
    #   zi foo    - interactive selection with fzf
fi

# --- delta: better git diffs ---
if command -v delta &>/dev/null; then
    export GIT_PAGER="delta"
fi
