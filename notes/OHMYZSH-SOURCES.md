# oh-my-zsh 安装与插件来源

本体(不收录,是 git 仓库): git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
主题: brew install powerlevel10k (已含于 Brewfile;.zshrc 中 ZSH_THEME="powerlevel10k/powerlevel10k")
自定义插件(需装进 ~/.oh-my-zsh/custom/plugins/):
- zsh-autosuggestions    → git clone https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting → git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
- zsh-edit-select         → git clone https://github.com/Michael-Matta1/zsh-edit-select.git
注意: .zshrc 直接 source 这三个插件路径;brew 版 zsh-autosuggestions/syntax-highlighting 亦已安装
