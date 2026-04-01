#!/usr/bin/env bash
set -e

echo "▶ Updating apt repositories..."
sudo apt update

echo "▶ Installing base packages..."
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

# Install eza (modern ls replacement) for Ubuntu
if ! command -v eza >/dev/null 2>&1; then
    echo "▶ Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo tee /etc/apt/keyrings/gierens.asc >/dev/null
    sudo chmod -R 644 /etc/apt/keyrings/gierens.asc
    echo "deb [signed-by=/etc/apt/keyrings/gierens.asc] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo apt update
    sudo apt install -y eza
fi

# Install tldr (tealdeer in Rust)
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

echo "✅ Ubuntu base packages installed!"