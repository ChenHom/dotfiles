#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles"
cd "$DOTFILES_DIR"

# 只有在 macOS 且安裝了 brew 時才更新 Brewfile
OS="$(uname -s)"
if [ "$OS" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    echo "Updating Brewfile..."
    brew bundle dump --force --describe --file="$DOTFILES_DIR/Brewfile"
fi

# 檢查 Git 狀態
if [[ -n $(git status -s) ]]; then
    echo "Changes detected, syncing to GitHub..."
    git add .
    git commit -m "Auto-backup: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin master # 或您的預設分支名稱
else
    echo "No changes to sync."
fi