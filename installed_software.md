#installed

### iTerm2
```bash
curl -L -o /tmp/iterm2.zip https://iterm2.com/downloads/stable/latest && unzip -q /tmp/iterm2.zip -d /Applications/ && rm /tmp/iterm2.zip

```

### Itsycal
```bash
curl -L -o /tmp/Itsycal.zip https://itsycal.s3.amazonaws.com/Itsycal.zip && unzip -q /tmp/Itsycal.zip -d /Applications/ && rm /tmp/Itsycal.zip
```

### install brew oh-my-zsh powerlevel10k 
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k && \
sed -i '' 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc && \
sed -i '' 's/# export LANG=en_US.UTF-8/export LANG=en_US.UTF-8/' $HOME/.zshrc && \
sed -i '' 's/plugins=(git)/plugins=(git auto-completion)/' $HOME/.zshrc && \
echo ~/.exports >> $HOME/.zshrc && \
echo ~/.aliases >> $HOME/.zshrc && \
source $HOME/.zshrc

```
### eza fzf orbstack

```bash
brew install eza fzf orbstack
```

### vs code
```bash
# vs code
brew install --cask visual-studio-code
```
