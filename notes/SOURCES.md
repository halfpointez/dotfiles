# 未收录项来源与复现方法

| 项目 | 状态 | 说明 |
|------|------|------|
| clash-verge | 已排除 | ~/.config/clash-verge/ 含订阅链接与 geoip 大文件,敏感不收录。复现: brew install --cask clash-verge-rev |
| nnn | 仅记录 | ~/.config/nnn/plugins 为官方插件包(jarun/nnn),可下载: https://github.com/jarun/nnn/tree/master/plugins |
| oh-my-zsh 本体 | 已排除 | git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh (见 OHMYZSH-SOURCES.md) |
| tmux 插件 | 已排除 | tpm + tmux-dotbar,由 .tmux.conf 中 @plugin 声明,首次进入 tmux 按 Prefix+I 安装 |
| sketchybar_backup | 已收录 | 见 sketchybar/backup/ |
| AeroSpace | 已废弃 | ~/.aerospace.toml# 为空残留文件,omit;曾尝试但改用 yabai |
| bottom | 已排除 | 配置文件为空 |
| 字体 | 已在 Brewfile | font-googlesanscode-nerd-font, font-sf-mono, font-sf-pro, sf-symbols |
| 代理脚本 | 见 .zshrc | proxy-on/proxy-off 别名已随 zsh 配置收录 |
