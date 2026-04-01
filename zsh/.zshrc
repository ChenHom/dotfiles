# 啟用 Powerlevel10k 的 instant prompt 功能
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 1. 環境變數設定 (在載入 OMZ 前必須完成)
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export EDITOR='vim'
export COLORTERM=truecolor

# 2. 設定主題與插件
ZSH_THEME="powerlevel10k"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

# 3. 載入 Oh My Zsh (不靜音，以便看到報錯)
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "⚠️  Oh My Zsh not found at $ZSH. Please run ./install.sh"
fi

# 4. 載入自定義配置
[ -f ~/.secrets ] && source ~/.secrets
source ~/.aliases
source ~/.exports
source ~/.fzf
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

# 5. Znap 插件管理器相關設定
[[ -r ~/Repos/znap/znap.zsh ]] || git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

# 載入核心插件 (Znap 版)
znap source zsh-users/zsh-completions

# 6. 其他通用設定
DISABLE_AUTO_TITLE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS="true"
HIST_STAMPS="yyyy-mm-dd"

# 7. macOS 專屬設定
if [ "$(uname -s)" = "Darwin" ]; then
  export PATH="$HOME/.config/herd-lite/bin:$PATH"
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
  alias transcribe='$HOME/code/side-project/shell/soundToText/transcribe-helper.sh'
fi

# 8. 載入額外環境變數
[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"
