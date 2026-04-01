#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
OS="$(uname -s)"
BACKUP_DIR="$DOTFILES_DIR/backup/$(date +%Y%m%d_%H%M%S)"

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
        git zsh stow fzf jq bat curl wget unzip build-essential \
        python3 python3-pip xclip # xclip 用於支援 Linux 剪貼簿

    # Install eza
    if ! command -v eza >/dev/null 2>&1; then
        echo "▶ Installing eza..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo tee /etc/apt/keyrings/gierens.asc >/dev/null
        sudo chmod -R 644 /etc/apt/keyrings/gierens.asc
        echo "deb [signed-by=/etc/apt/keyrings/gierens.asc] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
        sudo apt update && sudo apt install -y eza
    fi

    # Install tldr
    if ! command -v tldr >/dev/null 2>&1; then
        echo "▶ Installing tldr..."
        sudo apt install -y tealdeer
        tldr --update || echo "⚠️  tldr update failed, skipping..."
    fi

    # Change default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "▶ Changing default shell to Zsh..."
        chsh -s "$(which zsh)" || echo "⚠️  Failed to change shell. You may need to run 'chsh -s $(which zsh)' manually."
    fi
}

# --- 自動安裝 Vim-Plug ---
setup_vim() {
    echo "▶ Setting up Vim-Plug..."
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || { echo "❌ Failed to download vim-plug"; return 1; }
    fi
    # 自動安裝 .vimrc 中定義的插件 (非互動式)
    echo "▶ Installing Vim plugins..."
    vim +PlugInstall +qall
}

# --- 備份現有衝突檔案 ---
backup_conflicts() {
    local pkg=$1
    echo "▶ Checking for conflicts in $pkg..."
    # 使用更廣泛的匹配模式來偵測 stow 的衝突訊息
    # 包含 "is not a symlink" 或 "neither a link nor a directory"
    stow -n -v -R -t "$HOME" "$pkg" 2>&1 | grep -E "neither a link nor a directory|is not a symlink" | awk -F': ' '{print $NF}' | while read -r file; do
        # 移除可能的前後空格
        file=$(echo "$file" | xargs)
        full_path="$HOME/$file"
        if [ -e "$full_path" ] && [ ! -L "$full_path" ]; then
            echo "⚠️  Backing up existing file: $file -> $BACKUP_DIR"
            mkdir -p "$BACKUP_DIR"
            mv "$full_path" "$BACKUP_DIR/"
        fi
    done
}

# --- 主流程 ---
echo "▶ Starting dotfiles installation for $OS..."

# 1. 系統軟體安裝
if [ "$OS" = "Darwin" ]; then install_macos
elif [ "$OS" = "Linux" ]; then install_ubuntu
else echo "❌ Unsupported OS: $OS"; exit 1; fi

# 2. 準備目錄
mkdir -p "$HOME/Repos" # 供 Znap 使用

# 手動下載核心 Zsh 插件，確保啟動不噴錯
echo "▶ Pre-cloning core Zsh plugins..."
[ ! -d "$HOME/Repos/znap" ] && git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/Repos/znap"
[ ! -d "$HOME/Repos/zsh-users/zsh-completions" ] && git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$HOME/Repos/zsh-users/zsh-completions"
[ ! -d "$HOME/Repos/aureliojargas/clitest" ] && git clone --depth 1 https://github.com/aureliojargas/clitest.git "$HOME/Repos/aureliojargas/clitest"

# 3. 部署設定檔
echo "▶ Deploying configurations using GNU Stow..."
STOW_PACKAGES="zsh vim npm"
[ "$OS" = "Darwin" ] && STOW_PACKAGES="$STOW_PACKAGES hammerspoon"

cd "$DOTFILES_DIR"
for pkg in $STOW_PACKAGES; do
    if [ -d "$pkg" ]; then
        backup_conflicts "$pkg"
        stow -R -t "$HOME" "$pkg"
    fi
done

# 4. 插件與工具初始化
setup_vim

# 初始化 Zsh (如果目前不是 zsh，則嘗試啟動一次來觸發 Znap)
if command -v zsh >/dev/null 2>&1; then
    echo "▶ Initializing Zsh plugins..."
    zsh -c "source $HOME/.zshrc && exit" || echo "⚠️  Zsh initialization finished with warnings."
fi

echo "✅ Dotfiles installation completed!"
echo "💡 If this is your first time, please restart your terminal."