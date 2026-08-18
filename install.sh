#!/usr/bin/env bash
set -euo pipefail
# 换机复现脚本:仅复制配置,不删改现有文件
DOTFILES="$HOME/dotfiles"

echo "==> 1/4 安装 brew 包与 cask 应用"
brew bundle install --file="$DOTFILES/brew/Brewfile"

echo "==> 2/4 复制 shell 配置"
cp "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
cp "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
cp "$DOTFILES/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

echo "==> 3/4 复制各应用配置"
mkdir -p "$HOME/.config/yabai" "$HOME/.config/karabiner" "$HOME/.config/sketchybar" "$HOME/.config/ghostty" "$HOME/.config/fastfetch" "$HOME/.config/btop"
cp -R "$DOTFILES/yabai/yabairc" "$HOME/.config/yabai/"
cp "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/"
cp -R "$DOTFILES/sketchybar/" "$HOME/.config/sketchybar/"
cp "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/"
cp "$DOTFILES/fastfetch/config.jsonc" "$HOME/.config/fastfetch/"
cp "$DOTFILES/btop/btop.conf" "$HOME/.config/btop/"
cp "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/Library/LaunchAgents"
cp "$DOTFILES/yabai/com.asmvik.yabai.plist" "$HOME/Library/LaunchAgents/"

echo "==> 4/4 提示后续手工步骤"
echo "  - 壁纸: 从 wallpapers/ 选用图片 (系统设置 → 壁纸)"
echo "  - yabai 服务: cp ~/dotfiles/yabai/com.asmvik.yabai.plist ~/Library/LaunchAgents/ && launchctl load ... (需 sudo yabai --load-sa)"
echo "  - sketchybar: brew services start sketchybar, 已完成 1/4"
echo "  - sketchybar 辅助二进制: cd ~/.config/sketchybar/helpers && make (bin/ 目录未提交,需编译)"
echo "  - oh-my-zsh 插件: 按 notes/OHMYZSH-SOURCES.md git clone 到 ~/.oh-my-zsh/custom/plugins/"
echo "  - 代理脚本: .zshrc 已含 proxy-on/proxy-off 别名,需 clash-verge 运行在 7890 端口"