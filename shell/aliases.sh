# Use colors
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
    alias grep='grep --color=auto'
fi

# eza: modern ls replacement (falls back to ls)
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -la --git --group-directories-first'
    alias la='eza -a'
    alias l='eza'
    alias lt='eza --tree --level=2'
else
    alias ll='ls -lah'
    alias la='ls -A'
    alias l='ls'
fi

# bat: cat with syntax highlighting
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
elif command -v batcat &>/dev/null; then
    # Debian/Ubuntu installs bat as batcat
    alias cat='batcat --paging=never'
    alias catp='batcat'
fi

# fd: modern find alternative
if command -v fd &>/dev/null; then
    # fd is already named fd
    :
elif command -v fdfind &>/dev/null; then
    # Debian/Ubuntu installs fd as fdfind
    alias fd='fdfind'
fi

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# Create a directory and cd into it
mcd() {
    mkdir -p "${1}" && cd "${1}"
}

# Jump to directory containing file
jump() {
    cd "$(dirname "${1}")"
}

# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}

# Execute a command in a specific directory
# cd into ${1}
# left shift all arguments, losing ${1}
# execute the rest of the arguments
xin() {
    (
        cd "${1}" && shift && "${@}"
    )
}

alias cdgr='cd "$(git root)"'

alias zshu='source ~/.zshrc'

dfu() {
    (
        cd ~/.dotfiles/ && git pull --ff-only && bash ~/.dotfiles/install
    )
}

alias sq=squeue
