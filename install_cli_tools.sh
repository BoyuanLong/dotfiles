#!/bin/bash
# Install modern CLI tools: fzf, ripgrep, bat, fd, eza, zoxide, delta
# Supports: macOS (Homebrew), Ubuntu/Debian (apt), Fedora (dnf), Arch (pacman)

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

TOOLS_BREW=(fzf ripgrep bat fd eza zoxide git-delta)
TOOLS_APT=(fzf ripgrep bat fd-find eza zoxide git-delta)
TOOLS_DNF=(fzf ripgrep bat fd-find eza zoxide git-delta)
TOOLS_PACMAN=(fzf ripgrep bat fd eza zoxide git-delta)

install_with_brew() {
    echo -e "${GREEN}Installing with Homebrew...${NC}"
    brew install "${TOOLS_BREW[@]}"
}

install_with_apt() {
    echo -e "${GREEN}Installing with apt...${NC}"

    # eza and git-delta are not in default Ubuntu repos; add sources if needed
    if ! apt-cache show eza &>/dev/null 2>&1; then
        echo -e "${YELLOW}Adding eza repository...${NC}"
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
    fi

    # Install what's available via apt
    local apt_tools=(fzf ripgrep bat fd-find eza zoxide)
    sudo apt install -y "${apt_tools[@]}" || true

    # delta: install from GitHub releases if not available via apt
    if ! command -v delta &>/dev/null; then
        echo -e "${YELLOW}Installing delta from GitHub releases...${NC}"
        local arch
        arch=$(dpkg --print-architecture)
        local delta_version
        delta_version=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        local delta_deb="git-delta_${delta_version}_${arch}.deb"
        curl -fsSL "https://github.com/dandavison/delta/releases/download/${delta_version}/${delta_deb}" -o "/tmp/${delta_deb}"
        sudo dpkg -i "/tmp/${delta_deb}"
        rm "/tmp/${delta_deb}"
    fi
}

install_with_dnf() {
    echo -e "${GREEN}Installing with dnf...${NC}"
    sudo dnf install -y "${TOOLS_DNF[@]}"
}

install_with_pacman() {
    echo -e "${GREEN}Installing with pacman...${NC}"
    sudo pacman -S --needed --noconfirm "${TOOLS_PACMAN[@]}"
}

# Detect package manager and install
echo "======================================"
echo "Installing modern CLI tools"
echo "======================================"
echo ""
echo "Tools: fzf, ripgrep (rg), bat, fd, eza, zoxide, delta"
echo ""

if command -v brew &>/dev/null; then
    install_with_brew
elif command -v apt &>/dev/null; then
    install_with_apt
elif command -v dnf &>/dev/null; then
    install_with_dnf
elif command -v pacman &>/dev/null; then
    install_with_pacman
else
    echo -e "${RED}No supported package manager found (brew, apt, dnf, pacman).${NC}"
    echo "Please install the following tools manually:"
    echo "  fzf       - https://github.com/junegunn/fzf"
    echo "  ripgrep   - https://github.com/BurntSushi/ripgrep"
    echo "  bat       - https://github.com/sharkdp/bat"
    echo "  fd        - https://github.com/sharkdp/fd"
    echo "  eza       - https://github.com/eza-community/eza"
    echo "  zoxide    - https://github.com/ajeetdsouza/zoxide"
    echo "  delta     - https://github.com/dandavison/delta"
    exit 1
fi

echo ""
echo -e "${GREEN}======================================"
echo "Installation complete!"
echo "======================================${NC}"
echo ""
echo "Reload your shell to activate: source ~/.zshrc"
echo ""

# Show what's available
for tool in fzf rg bat fd eza zoxide delta; do
    if command -v "$tool" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool"
    elif [[ "$tool" == "bat" ]] && command -v batcat &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool (as batcat)"
    elif [[ "$tool" == "fd" ]] && command -v fdfind &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool (as fdfind)"
    else
        echo -e "  ${RED}✗${NC} $tool - not found, install manually"
    fi
done
