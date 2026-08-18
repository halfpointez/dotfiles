# dotfiles — macOS i3 风格桌面配置

收集 yabai + sketchybar + karabiner-elements + oh-my-zsh + ghostty + tmux 等全套美化配置。

## 目录结构
| 目录 | 内容 |
|------|------|
| zsh/ | .zshrc, .zprofile, .p10k.zsh (powerlevel10k) |
| yabai/ | yabairc 平铺窗口管理器配置 + launchd plist |
| skhd/ | 已弃用的 skhd 配置备份 |
| karabiner/ | Karabiner-Elements 快捷键配置 (替代 skhd) |
| sketchybar/ | 顶栏 Lua 配置 + backup/ 旧版 |
| ghostty/ tmux/ fastfetch/ btop/ | 终端/复用器/系统信息/系统监控 |
| wallpapers/ | 壁纸 9 张 |
| brew/ | Brewfile 包清单 (brew bundle dump) |
| legacy/ | 已废弃配置 (omniwm, yabai skhd 备份) |
| notes/ | 未收录项来源与复现方法 (SOURCES.md) |
| install.sh | 换机一键复现脚本 |

## 换机复现
bash ~/dotfiles/install.sh