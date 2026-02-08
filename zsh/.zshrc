# 啟用 Powerlevel10k 的 instant prompt 功能
# 該部分必須保持在檔案的最前面，避免影響 zsh 的啟動速度
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 設置 Oh My Zsh 的安裝路徑
export ZSH="$HOME/.oh-my-zsh"

# 設定使用的主題
ZSH_THEME="powerlevel10k/powerlevel9k" # set by `omz`

# 插件列表，根據需求選擇合適的插件
plugins=(
  git                        # Git 支援
  zsh-autosuggestions        # 提供命令建議
  1password                  # 1Password 支援
#   history-substring-search   # 支援歷史命令子字串搜索
)

# 避免產生輸出
# 載入 Oh My Zsh
# 如果存在個性化設定文件，則載入 Powerlevel10k 的設定
# 載入用戶自定義的別名
# 載入用戶自定義的環境變數
# 載入 fzf 的設定
{
  source $ZSH/oh-my-zsh.sh
  [[ ! -f ~/.secrets ]] || source ~/.secrets
  source ~/.aliases
  source ~/.exports
  source ~/.fzf
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
} &>/dev/null

# Dotfiles 同步別名
alias dotsync="~/.dotfiles/sync.sh"


# Znap 插件管理器相關設定
# 如果 Znap 還未下載，則自動從 GitHub 克隆
[[ -r ~/Repos/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap

# 載入 Znap
source ~/Repos/znap/znap.zsh

# 載入 Znap 管理的插件
znap prompt sindresorhus/pure              # 快速顯示 Prompt
# znap source marlonrichert/zsh-autocomplete # 提供自動完成功能

# 使用 Znap 提升某些命令的執行速度
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'

# 定義 Znap 功能，實現按需載入
znap function _pyenv pyenv "znap eval pyenv 'pyenv init - --no-rehash'"
compctl -K _pyenv pyenv

# Znap 安裝其他工具和自動完成支援
znap install aureliojargas/clitest zsh-users/zsh-completions

# 用於自定義自動完成的設定
bindkey -M emacs '^I' expand-or-complete

# 其他通用設定
# 設定啟動時更改終端標題
DISABLE_AUTO_TITLE="true"

# 關閉某些 Oh My Zsh 內建功能以提升速度
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS="true"

# 提供命令執行歷史的格式
HIST_STAMPS="yyyy-mm-dd"
export PATH="/Users/hom/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/hom/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

. "$HOME/.local/share/../bin/env"




# 音檔轉繁體中文逐字稿工具 - 智慧路徑版本
alias transcribe='/Users/hom/code/side-project/shell/soundToText/transcribe-helper.sh'
alias transcribe-srt='/Users/hom/code/side-project/shell/soundToText/transcribe-helper.sh -f srt'
alias transcribe-vtt='/Users/hom/code/side-project/shell/soundToText/transcribe-helper.sh -f vtt'
alias transcribe-small='/Users/hom/code/side-project/shell/soundToText/transcribe-helper.sh -m small'
alias transcribe-large='/Users/hom/code/side-project/shell/soundToText/transcribe-helper.sh -m large'
