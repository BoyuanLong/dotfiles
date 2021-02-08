# Use colors
if [[ "$OSTYPE" == "linux-gnu"* ]]; then 
    alias ls='ls --color=auto'
    alias grep='grep --color'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
    alias grep='grep -G'
fi

# ls aliases
# ls everything in list format
alias ll='ls -lah'
# ls everything except for . and ..
alias la='ls -A'
# short name for ls
alias l='ls'

# Aliases to protect agianst overwritting
alias cp='cp -i'
alias mv='mv -i'

# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}

# Jump to directory containing file
jump() {
    cd "$(dirname ${1})"
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

