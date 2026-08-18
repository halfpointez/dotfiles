# Dotfiles 收集整理 + GitHub 上传 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 macOS i3 风格美化所有散落配置(约 15 个组件 + 壁纸)整理进 `~/dotfiles/`,并创建公开 GitHub 仓库推送。

**Architecture:** 只读复制所有配置文件进 `~/dotfiles/` 按组件分目录;遗留/弃用项与敏感项不复制,以 `notes/SOURCES.md` 记录来源与复现方法;`Brewfile` + `install.sh` 保证换机可复现。✅ 只收集,**不修改任何现有配置**。

**Tech Stack:** git, GitHub CLI (gh), brew bundle, shell

**Spec:** 用户需求 — 找出 yabai/oh-my-zsh/Karabiner-Elements 等全部美化配置 → 整理进 desktop 文件夹(确认改为 `~/dotfiles`) → 装 gh CLI 自动创建**公开**仓库并推送;不需要的项以文本/脚本保留来源。用户补充要求:执行前先完整备份且可恢复,推送成功后再尝试 symlink 重定向。

## Global Constraints

- 只复制与文档化,绝不修改源文件(`~/.config/*`, `~/.zshrc` 等一律不动);重定向 symlink 阶段是唯一例外(在 Task 12 推送成功之后、且已备份的前提下)
- 敏感/巨型二进制不收录:clash-verge(含订阅链接)、nnn plugins 包、oh-my-zsh 本体(git 仓库)
- 组件若本身是 git clone(oh-my-zsh、zsh 插件、tmux 插件)→ 记录来源 URL,不复制
- 提交信息用中文,风格 `chore: ...` / `feat: ...`
- 备份目录为 `~/dotfiles-backup-2026-08-18/`,备份必须 diff 验证通过后才开始收集

---

### Task 1: 完整备份全部源配置(可恢复)

**Files:**
- Create: `~/dotfiles-backup-2026-08-18/`(镜像全部源配置)
- Create: `~/dotfiles-backup-2026-08-18/RESTORE.sh`(一键恢复脚本)

**Interfaces:** 产生备份目录供 Task 13 回滚;Task 2-10 收集时源文件若意外损坏可从备份恢复

- [ ] **Step 1: 创建备份目录并镜像全部源配置**

```bash
BK=~/dotfiles-backup-2026-08-18
mkdir -p "$BK/zsh" "$BK/yabai" "$BK/karabiner" "$BK/sketchybar" "$BK/sketchybar_backup" "$BK/ghostty" "$BK/tmux" "$BK/fastfetch" "$BK/btop" "$BK/legacy" "$BK/pic" "$BK/LaunchAgents"
cp ~/.zshrc ~/.zprofile ~/.p10k.zsh ~/.zshrc.pre-oh-my-zsh "$BK/zsh/"
cp ~/.config/yabai/yabairc ~/.yabairc.bak "$BK/yabai/"
cp ~/.skhdrc.bak "$BK/legacy/"
cp ~/.config/karabiner/karabiner.json "$BK/karabiner/"
cp -R ~/.config/sketchybar/. "$BK/sketchybar/"
cp -R ~/.config/sketchybar_backup/. "$BK/sketchybar_backup/"
cp ~/.config/ghostty/config "$BK/ghostty/"
cp ~/.tmux.conf "$BK/tmux/"
cp ~/.config/fastfetch/config.jsonc "$BK/fastfetch/"
cp ~/.config/btop/btop.conf "$BK/btop/"
cp ~/.config/omniwm/settings.toml "$BK/legacy/"
cp ~/.gitconfig "$BK/legacy/"
cp /Applications/development/desktop/pic/* "$BK/pic/"
cp ~/Library/LaunchAgents/com.asmvik.yabai.plist ~/Library/LaunchAgents/homebrew.mxcl.sketchybar.plist "$BK/LaunchAgents/"
```

- [ ] **Step 2: 逐项 diff 验证备份完整**

```bash
BK=~/dotfiles-backup-2026-08-18
diff ~/.zshrc "$BK/zsh/.zshrc" && diff ~/.p10k.zsh "$BK/zsh/.p10k.zsh" && echo ZSH_OK
diff ~/.config/yabai/yabairc "$BK/yabai/yabairc" && diff ~/.yabairc.bak "$BK/yabai/yabairc.bak" && echo YABAI_OK
diff ~/.config/karabiner/karabiner.json "$BK/karabiner/karabiner.json" && echo KARABINER_OK
diff -r ~/.config/sketchybar "$BK/sketchybar" --exclude='.DS_Store' && echo SKETCH_OK
diff -r ~/.config/sketchybar_backup "$BK/sketchybar_backup" --exclude='.DS_Store' && echo SKETCH_BACKUP_OK
diff ~/.tmux.conf "$BK/tmux/.tmux.conf" && echo TMUX_OK
diff ~/.gitconfig "$BK/legacy/.gitconfig" && echo GITCONFIG_OK
diff -r /Applications/development/desktop/pic "$BK/pic" --exclude='.DS_Store' && echo PIC_OK
ls "$BK/LaunchAgents/"  # 应列出 2 个 plist
```

- [ ] **Step 3: 写 RESTORE.sh(可在重定向回滚或任何损坏时一键恢复)**

```bash
#!/usr/bin/env bash
set -euo pipefail
# 恢复本机配置到备份时的状态(2018-08-18 备份)
BK="$(cd "$(dirname "$0")" && pwd)"
cp "$BK/zsh/.zshrc" ~/.zshrc
cp "$BK/zsh/.zprofile" ~/.zprofile
cp "$BK/zsh/.p10k.zsh" ~/.p10k.zsh
cp "$BK/zsh/.zshrc.pre-oh-my-zsh" ~/.zshrc.pre-oh-my-zsh
mkdir -p ~/.config
cp "$BK/yabai/yabairc" ~/.config/yabai/yabairc
cp "$BK/yabai/yabairc.bak" ~/.yabairc.bak
cp "$BK/legacy/skhdrc.bak" ~/.skhdrc.bak
cp "$BK/karabiner/karabiner.json" ~/.config/karabiner/
cp -R "$BK/sketchybar/." ~/.config/sketchybar/
cp -R "$BK/sketchybar_backup/." ~/.config/sketchybar_backup/
cp "$BK/ghostty/config" ~/.config/ghostty/
cp "$BK/tmux/.tmux.conf" ~/.tmux.conf
cp "$BK/fastfetch/config.jsonc" ~/.config/fastfetch/
cp "$BK/btop/btop.conf" ~/.config/btop/
cp "$BK/legacy/omniwm-settings.toml" ~/.config/omniwm/settings.toml
cp "$BK/legacy/.gitconfig" ~/.gitconfig
cp "$BK/LaunchAgents/com.asmvik.yabai.plist" ~/Library/LaunchAgents/
cp "$BK/LaunchAgents/homebrew.mxcl.sketchybar.plist" ~/Library/LaunchAgents/
echo "恢复完成。如需恢复壁纸: cp -R \"$BK/pic/.\" /Applications/development/desktop/pic/"
```

- [ ] **Step 4: 验证 RESTORE.sh 语法与可执行**

```bash
chmod +x ~/dotfiles-backup-2026-08-18/RESTORE.sh
bash -n ~/dotfiles-backup-2026-08-18/RESTORE.sh && echo SYNTAX_OK
```

- [ ] **Step 5: 提交(备份目录在 ~/dotfiles 仓库外,无需 git 提交;本任务在备份验证通过前不可进入下一任务)**

```bash
# 无需 git 提交。验收标准: Step 2 全部 diff 输出 OK,Step 3 文件存在且语法合法
```

---

### Task 2: 创建仓库骨架

**Files:**
- Create: `~/dotfiles/README.md`(骨架,Task 11 补全)
- Create: `~/dotfiles/.gitignore`

**Interfaces:** 产生仓库目录结构 `zsh/ yabai/ skhd/ karabiner/ sketchybar/ ghostty/ tmux/ fastfetch/ btop/ bottom/ wallpapers/ legacy/ notes/ brew/git`

- [ ] **Step 1: 创建目录结构**

```bash
cd ~/dotfiles
mkdir -p zsh yabai skhd karabiner sketchybar/backup ghostty tmux fastfetch btop bottom wallpapers legacy notes brew git docs
```

- [ ] **Step 2: 写 .gitignore**

```
.DS_Store
*.log
```

- [ ] **Step 3: 写 README 骨架**

```markdown
# dotfiles — macOS i3 风格桌面配置

本仓库收集并整理 macOS 上 yabai + sketchybar + karabiner-elements + oh-my-zsh 等美化配置,便于换机复现。
详见下方各目录与 `notes/SOURCES.md`。
```

- [ ] **Step 4: 验证**

```bash
ls ~/dotfiles/  # 应看到全部目录 + .gitignore + README.md
```

- [ ] **Step 5: Commit**

```bash
cd ~/dotfiles && git add . && git commit -m "chore: 初始化 dotfiles 仓库骨架"
```

---

### Task 3: 导出 Brewfile

**Files:**
- Create: `~/dotfiles/brew/Brewfile`

**Interfaces:** 供 Task 11 的 install.sh 使用(`brew bundle install --file=...`)

- [ ] **Step 1: 导出当前 brew 包清单**

```bash
brew bundle dump --file=~/dotfiles/brew/Brewfile --describe --force
```

- [ ] **Step 2: 验证**

```bash
c=$(grep -c -E '^(brew |cask )' ~/dotfiles/brew/Brewfile); echo "entries=$c"; [ "$c" -ge 50 ] && echo OK
grep -E '^cask ' ~/dotfiles/brew/Brewfile  # 应含 ghostty, karabiner-elements, omniwm, 字体
grep -E 'yabai|sketchybar|powerlevel10k' ~/dotfiles/brew/Brewfile
```

- [ ] **Step 3: Commit**

```bash
cd ~/dotfiles && git add brew/ && git commit -m "feat: 导出 brew 包清单 Brewfile"
```

---

### Task 4: 收集 zsh / oh-my-zsh 配置

**Files:**
- Create: `~/dotfiles/zsh/.zshrc` ← 复制 `~/.zshrc`
- Create: `~/dotfiles/zsh/.zprofile` ← 复制 `~/.zprofile`
- Create: `~/dotfiles/zsh/.p10k.zsh` ← 复制 `~/.p10k.zsh`
- Create: `~/dotfiles/legacy/zshrc.pre-oh-my-zsh` ← 复制 `~/.zshrc.pre-oh-my-zsh`
- Create: `~/dotfiles/notes/OHMYZSH-SOURCES.md`(插件来源记录)

**Interfaces:** 产生插件来源清单供 Task 11 install.sh 使用

- [ ] **Step 1: 复制文件**

```bash
cp ~/.zshrc ~/.zprofile ~/.p10k.zsh ~/dotfiles/zsh/
cp ~/.zshrc.pre-oh-my-zsh ~/dotfiles/legacy/
```

- [ ] **Step 2: 写插件来源记录**

```markdown
# oh-my-zsh 安装与插件来源

本体(不收录,是 git 仓库): git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
主题: brew install powerlevel10k (已含于 Brewfile;.zshrc 中 ZSH_THEME="powerlevel10k/powerlevel10k")
自定义插件(需装进 ~/.oh-my-zsh/custom/plugins/):
- zsh-autosuggestions    → git clone https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting → git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
- zsh-edit-select         → git clone https://github.com/Michael-Matta1/zsh-edit-select.git
注意: .zshrc 直接 source 这三个插件路径;brew 版 zsh-autosuggestions/syntax-highlighting 亦已安装
```

- [ ] **Step 3: 验证**

```bash
ls -la ~/dotfiles/zsh/   # 3 个文件, .p10k.zsh 约 95KB
diff ~/.zshrc ~/dotfiles/zsh/.zshrc && echo OK
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add zsh/ legacy/ notes/ && git commit -m "feat: 收集 zsh/oh-my-zsh 配置及插件来源"
```

---

### Task 5: 收集 yabai + launchd + skhd 备份

**Files:**
- Create: `~/dotfiles/yabai/yabairc` ← 复制 `~/.config/yabai/yabairc`
- Create: `~/dotfiles/yabai/com.asmvik.yabai.plist` ← 复制 `~/Library/LaunchAgents/com.asmvik.yabai.plist`
- Create: `~/dotfiles/skhd/skhdrc.bak` ← 复制 `~/.skhdrc.bak`(附说明:已被 karabiner 取代)
- Create: `~/dotfiles/legacy/yabairc.bak` ← 复制 `~/.yabairc.bak`
- Create: `~/dotfiles/skhd/README.md`

- [ ] **Step 1: 复制文件**

```bash
cp ~/.config/yabai/yabairc ~/dotfiles/yabai/
cp ~/Library/LaunchAgents/com.asmvik.yabai.plist ~/dotfiles/yabai/
cp ~/.skhdrc.bak ~/dotfiles/skhd/ && cp ~/.yabairc.bak ~/dotfiles/legacy/
```

- [ ] **Step 2: 在 `~/dotfiles/skhd/README.md` 注明用途**

```markdown
# skhd (已弃用)

skhd 已停止使用并被 Karabiner-Elements 完全取代(见 ../karabiner/)。
skhdrc.bak 为最终备份,包含 Alt+hjkl 窗口焦点/移动/缩放映射,供参考。
```

- [ ] **Step 3: 验证**

```bash
diff ~/.config/yabai/yabairc ~/dotfiles/yabai/yabairc && echo OK
diff ~/.skhdrc.bak ~/dotfiles/skhd/skhdrc.bak && echo OK
plutil -lint ~/dotfiles/yabai/com.asmvik.yabai.plist   # 输出 OK
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add yabai/ skhd/ legacy/ && git commit -m "feat: 收集 yabai 配置、launchd plist 及 skhd 备份"
```

---

### Task 6: 收集 Karabiner-Elements 配置

**Files:**
- Create: `~/dotfiles/karabiner/karabiner.json` ← 复制 `~/.config/karabiner/karabiner.json`

**Interfaces:** 为 Task 11 提供「换机导入路径」: `~/.config/karabiner/karabiner.json`

- [ ] **Step 1: 复制配置文件**

```bash
cp ~/.config/karabiner/karabiner.json ~/dotfiles/karabiner/
```

- [ ] **Step 2: 验证 JSON 合法且无遗漏**

```bash
jq -e '.profiles[0].name' ~/dotfiles/karabiner/karabiner.json && echo VALID
diff ~/.config/karabiner/karabiner.json ~/dotfiles/karabiner/karabiner.json && echo OK
grep -c shell_command ~/dotfiles/karabiner/karabiner.json   # 应 > 10 (yabai 快捷键)
```

- [ ] **Step 3: Commit**

```bash
cd ~/dotfiles && git add karabiner/ && git commit -m "feat: 收集 karabiner-elements 配置"
```

---

### Task 7: 收集 sketchybar 顶栏配置

**Files:**
- Create: `~/dotfiles/sketchybar/**` ← 复制 `~/.config/sketchybar/` 全部内容(bar.lua, colors.lua, default.lua, helpers/, icons.lua, init.lua, items/, settings.lua, sketchybarrc)
- Create: `~/dotfiles/sketchybar/backup/` ← 复制 `~/.config/sketchybar_backup/` 全部(旧版 shell 脚本版)
- Create: `~/dotfiles/sketchybar/README.md`

- [ ] **Step 1: 复制两套配置**

```bash
cp -R ~/.config/sketchybar/. ~/dotfiles/sketchybar/
cp -R ~/.config/sketchybar_backup/. ~/dotfiles/sketchybar/backup/
```

- [ ] **Step 2: 验证完整性**

```bash
diff -r ~/.config/sketchybar ~/dotfiles/sketchybar --exclude='.DS_Store' --exclude='README.md' --exclude='backup' && echo OK
diff -r ~/.config/sketchybar_backup ~/dotfiles/sketchybar/backup --exclude='.DS_Store' && echo OK
find ~/dotfiles/sketchybar -name '*.lua' | wc -l   # 应 ≥ 10
```

- [ ] **Step 3: 在 `~/dotfiles/sketchybar/README.md` 注明来源**

```markdown
# sketchybar

- Lua 版(当前使用): 根目录内容,由 sketchybar 读取 ~/.config/sketchybar/
- 旧版 shell 脚本版: backup/ 目录,已弃用
- 服务: brew services start sketchybar (launchd plist 由 brew 生成,见 brew/Brewfile)
- 参考来源: FelixKratz/SketchyBar
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add sketchybar/ && git commit -m "feat: 收集 sketchybar 顶栏配置(含旧版备份)"
```

---

### Task 8: 收集 ghostty / tmux / fastfetch / btop / bottom

**Files:**
- Create: `~/dotfiles/ghostty/config` ← 复制 `~/.config/ghostty/config`
- Create: `~/dotfiles/tmux/.tmux.conf` ← 复制 `~/.tmux.conf`
- Create: `~/dotfiles/fastfetch/config.jsonc` ← 复制 `~/.config/fastfetch/config.jsonc`
- Create: `~/dotfiles/btop/btop.conf` ← 复制 `~/.config/btop/btop.conf`
- Create: `~/dotfiles/bottom/README.md`(说明 bottom.toml 为空,未收录)

- [ ] **Step 1: 复制各配置**

```bash
cp ~/.config/ghostty/config ~/dotfiles/ghostty/
cp ~/.tmux.conf ~/dotfiles/tmux/
cp ~/.config/fastfetch/config.jsonc ~/dotfiles/fastfetch/
cp ~/.config/btop/btop.conf ~/dotfiles/btop/
```

- [ ] **Step 2: 写 bottom 说明**

```markdown
# bottom

~/.config/bottom/bottom.toml 为空文件(默认配置),无需收录。
```

- [ ] **Step 3: 验证**

```bash
diff ~/.tmux.conf ~/dotfiles/tmux/.tmux.conf && echo OK
ls -la ~/dotfiles/{ghostty,fastfetch,btop}/   # 各 1 个文件
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add ghostty/ tmux/ fastfetch/ btop/ bottom/ && git commit -m "feat: 收集 ghostty/tmux/fastfetch/btop 配置"
```

---

### Task 9: 收集壁纸(约 30MB)

**Files:**
- Create: `~/dotfiles/wallpapers/` ← 复制 `/Applications/development/desktop/pic/` 下 9 张图片 + ascii art

- [ ] **Step 1: 复制全部壁纸**

```bash
cp -v /Applications/development/desktop/pic/* ~/dotfiles/wallpapers/
```

- [ ] **Step 2: 验证总数与大小**

```bash
ls ~/dotfiles/wallpapers/ | wc -l   # 应为 10 (9 图 + 1 txt)
du -sh ~/dotfiles/wallpapers/        # 约 30M
```

- [ ] **Step 3: Commit**

```bash
cd ~/dotfiles && git add wallpapers/ && git commit -m "feat: 收录壁纸 9 张"
```

---

### Task 10: 收集遗留配置并编写来源说明

**Files:**
- Create: `~/dotfiles/legacy/omniwm-settings.toml` ← 复制 `~/.config/omniwm/settings.toml`
- Create: `~/dotfiles/notes/SOURCES.md`(全部未收录项的来源与复现方法)
- Create: `~/dotfiles/git/.gitconfig` ← 复制 `~/.gitconfig`(git 身份;注意 email 会公开,若介意可省略该文件,改在 Task 11 说明)

**Interfaces:** 为 Task 11 的 install.sh 提供所有安装来源

- [ ] **Step 1: 复制 omniwm 与 gitconfig**

```bash
cp ~/.config/omniwm/settings.toml ~/dotfiles/legacy/omniwm-settings.toml
cp ~/.gitconfig ~/dotfiles/git/
```

- [ ] **Step 2: 写 SOURCES.md**

```markdown
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
```

- [ ] **Step 3: 验证**

```bash
ls ~/dotfiles/legacy/   # omniwm-settings.toml, yabairc.bak, zshrc.pre-oh-my-zsh
head -5 ~/dotfiles/notes/SOURCES.md
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add legacy/ notes/ git/ && git commit -m "feat: 收集遗留配置并编写来源复现说明"
```

---

### Task 11: 编写换机复现脚本 install.sh 与完整 README

**Files:**
- Create: `~/dotfiles/install.sh`(可执行)
- Modify: `~/dotfiles/README.md`(补全完整文档)

**Interfaces:** 消费 Task 3 的 Brewfile、Task 4 的来源记录、Task 6 的 karabiner 路径

- [ ] **Step 1: 写 install.sh**

```bash
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
echo "  - oh-my-zsh 插件: 按 notes/OHMYZSH-SOURCES.md git clone 到 ~/.oh-my-zsh/custom/plugins/"
echo "  - 代理脚本: .zshrc 已含 proxy-on/proxy-off 别名,需 clash-verge 运行在 7890 端口"
```

- [ ] **Step 2: 补全 README.md** — 加入安装说明与目录结构表:

```markdown
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
```

- [ ] **Step 3: 验证**

```bash
bash -n ~/dotfiles/install.sh && echo SYNTAX_OK
chmod +x ~/dotfiles/install.sh
```

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles && git add install.sh README.md && git commit -m "docs: 添加换机复现脚本与完整 README"
```

---

### Task 12: 安装 gh CLI 并创建公开仓库推送

**Files:** 无(系统变更:`brew install gh`)

- [ ] **Step 1: 安装 gh**

```bash
brew install gh
```

- [ ] **Step 2: 登录 GitHub(需要用户在浏览器完成授权;若 gh 已登录则跳过)**

```bash
gh auth status 2>&1 | grep -q "Logged in" || gh auth login --hostname github.com --git-protocol https --web
```

- [ ] **Step 3: 创建公开仓库并推送**

```bash
cd ~/dotfiles
gh repo create dotfiles --public --source=. --remote=origin --push
```

- [ ] **Step 4: 验证**

```bash
gh repo view halfpointez/dotfiles --json name,visibility -q '.name + " (" + .visibility + ")"'   # 期望 dotfiles (PUBLIC)
git -C ~/dotfiles log --oneline | wc -l    # 应 ≥ 10 个提交
```

- [ ] **Step 5: 若 Step 3 失败则回退方案:提示用户网页创建后手动推送**

```bash
git remote add origin git@github.com:halfpointez/dotfiles.git
git push -u origin main
```

---

### Task 13: 重定向 symlink 到 dotfiles(推送成功后执行)

**Files:** 修改(创建 symlink 替换)以下位置:
- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`
- `~/.zprofile` → `~/dotfiles/zsh/.zprofile`
- `~/.p10k.zsh` → `~/dotfiles/zsh/.p10k.zsh`
- `~/.tmux.conf` → `~/dotfiles/tmux/.tmux.conf`
- `~/.config/yabai/yabairc` → `~/dotfiles/yabai/yabairc`
- `~/.config/karabiner/karabiner.json` → `~/dotfiles/karabiner/karabiner.json` (注:karabiner 偶尔会重写此文件,若替换坑位 symlink 则恢复为普通文件,内容已在 git 中不丢失)
- `~/.config/sketchybar/` → `~/dotfiles/sketchybar/` (整目录 symlink)
- `~/.config/ghostty/config` → `~/dotfiles/ghostty/config`
- `~/.config/fastfetch/config.jsonc` → `~/dotfiles/fastfetch/config.jsonc`
- `~/.config/btop/btop.conf` → `~/dotfiles/btop/btop.conf`
- `~/.gitconfig` → `~/dotfiles/git/.gitconfig`

**Interfaces:** 消费 Task 1 的备份(回滚用 RESTORE.sh)与 Task 2-10 的仓库文件;仅在 Task 12 推送成功验证后执行

- [ ] **Step 1: 逐项检查目标可 symlink 且源已存在**

```bash
for f in ~/dotfiles/zsh/.zshrc ~/dotfiles/zsh/.zprofile ~/dotfiles/zsh/.p10k.zsh ~/dotfiles/tmux/.tmux.conf ~/dotfiles/yabai/yabairc ~/dotfiles/karabiner/karabiner.json ~/dotfiles/sketchybar ~/dotfiles/ghostty/config ~/dotfiles/fastfetch/config.jsonc ~/dotfiles/btop/btop.conf ~/dotfiles/git/.gitconfig; do
  [ -e "$f" ] && echo "EXISTS: $f" || echo "MISSING: $f"
done
```

- [ ] **Step 2: 创建各 symlink(先 mv 原文件为 .orig,再 ln -s;所有原文件已有 Task 1 备份,此步仍保留 .orig 以便快速回滚)**

```bash
ln -sf ~/dotfiles/zsh/.zshrc            ~/.zshrc
ln -sf ~/dotfiles/zsh/.zprofile         ~/.zprofile
ln -sf ~/dotfiles/zsh/.p10k.zsh         ~/.p10k.zsh
ln -sf ~/dotfiles/tmux/.tmux.conf       ~/.tmux.conf
ln -sf ~/dotfiles/yabai/yabairc         ~/.config/yabai/yabairc
ln -sf ~/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
rm -rf ~/.config/sketchybar && ln -s ~/dotfiles/sketchybar ~/.config/sketchybar
ln -sf ~/dotfiles/ghostty/config        ~/.config/ghostty/config
ln -sf ~/dotfiles/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
ln -sf ~/dotfiles/btop/btop.conf        ~/.config/btop/btop.conf
ln -sf ~/dotfiles/git/.gitconfig        ~/.gitconfig
```

注意: `~/.config/sketchybar` 目录被 rm -rf 是因为整目录 symlink;备份已在 Task 1 完成且仓库内有完整副本,可随时恢复。

- [ ] **Step 3: 验证 symlink 全部生效**

```bash
ls -la ~/.zshrc ~/.zprofile ~/.p10k.zsh ~/.tmux.conf ~/.config/yabai/yabairc ~/.config/karabiner/karabiner.json ~/.config/sketchybar ~/.config/ghostty/config ~/.config/fastfetch/config.jsonc ~/.config/btop/btop.conf ~/.gitconfig
# 每条输出应含 -> ~/dotfiles/... 的箭头
```

- [ ] **Step 4: 验证服务仍正常(重启 sketchybar 与 yabai 并确认)**

```bash
brew services restart sketchybar && sleep 2 && pgrep -l sketchybar   # 应输出进程号
launchctl kickstart -k gui/$(id -u)/com.asmvik.yabai && sleep 2 && pgrep -l yabai   # 应输出进程号
```

- [ ] **Step 5: 若任一服务失败 → 立即回滚**

```bash
bash ~/dotfiles-backup-2026-08-18/RESTORE.sh
echo "已回滚到备份状态,仓库与远程保持完好"
```

- [ ] **Step 6: 提交 empty baseline 提交作为重定向完成标记**

```bash
cd ~/dotfiles && git commit -m "chore: 重定向配置文件为 symlink 后 baseline" --allow-empty
```