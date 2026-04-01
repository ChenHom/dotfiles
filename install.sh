#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
OS="$(uname -s)"

# --- macOS 安裝流程 ---
install_macos() {
    echo "▶ macOS detected. Installing packages via Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "▶ Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="$DOTFILES_DIR/Brewfile"
}

# --- Ubuntu 安裝流程 ---
install_ubuntu() {
    echo "▶ Linux detected. Installing base packages via apt..."
    sudo apt update
    sudo apt install -y \
        git \
        zsh \
        stow \
        fzf \
        jq \
        bat \
        curl \
        wget \
        unzip \
        build-essential \
        python3 \
        python3-pip

    # Install eza (modern ls replacement)
    if ! command -v eza >/dev/null 2>&1; then
        echo "▶ Installing eza..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo tee /etc/apt/keyrings/gierens.asc >/dev/null
        sudo chmod -R 644 /etc/apt/keyrings/gierens.asc
        echo "deb [signed-by=/etc/apt/keyrings/gierens.asc] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
        sudo apt update
        sudo apt install -y eza
    fi

    # Install tldr (tealdeer)
    if ! command -v tldr >/dev/null 2>&1; then
        echo "▶ Installing tldr..."
        sudo apt install -y tealdeer
        tldr --update
    fi

    # Change default shell to Zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "▶ Changing default shell to Zsh..."
        chsh -s "$(which zsh)"
    fi
}

# --- 主流程 ---
echo "▶ Starting dotfiles installation for $OS..."

if [ "$OS" = "Darwin" ]; then
    install_macos
elif [ "$OS" = "Linux" ]; then
    install_ubuntu
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

# 透過 GNU Stow 建立軟連結佈署設定檔
echo "▶ Deploying configurations using GNU Stow..."

# Common packages (在各平台都適用的設定)
STOW_PACKAGES="zsh vim npm"

# OS specific packages
if [ "$OS" = "Darwin" ]; then
    STOW_PACKAGES="$STOW_PACKAGES hammerspoon"
fi

cd "$DOTFILES_DIR"
for pkg in $STOW_PACKAGES; do
    if [ -d "$pkg" ]; then
        echo "▶ Stowing $pkg..."
        # -R 代表 restow (若已存在則重新連結)，-t 指定目標目錄
        stow -R -t "$HOME" "$pkg"
    else
        echo "⚠️  Directory $pkg not found, skipping..."
    fi
done

echo "✅ Dotfiles installation completed!"