#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
cd "$DOTFILES_DIR"

# 更新 Brewfile
echo "Updating Brewfile..."
brew bundle dump --force --describe --file="$DOTFILES_DIR/Brewfile"

# 檢查 Git 狀態
if [[ -n $(git status -s) ]]; then
    echo "Changes detected, syncing to GitHub..."
    git add .
    git commit -m "Auto-backup: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin master # 或您的預設分支名稱
else
    echo "No changes to sync."
fi
