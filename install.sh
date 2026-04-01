#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
OS="$(uname -s)"

echo "▶ Starting dotfiles installation for $OS..."

# 1. 根據 OS 安裝軟體
if [ "$OS" = "Darwin" ]; then
    echo "▶ macOS detected. Installing packages via Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "▶ Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="$DOTFILES_DIR/Brewfile"

elif [ "$OS" = "Linux" ]; then
    echo "▶ Linux detected. Running Ubuntu installation script..."
    if [ -x "$DOTFILES_DIR/install_ubuntu.sh" ]; then
        "$DOTFILES_DIR/install_ubuntu.sh"
    else
        bash "$DOTFILES_DIR/install_ubuntu.sh"
    fi
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

# 2. 透過 GNU Stow 建立軟連結佈署設定檔
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