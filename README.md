# chsrc

> **One-click Linux system source & Docker mirror switcher**
> 一键切换 Linux 系统软件源与 Docker 镜像加速

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![ShellCheck](https://github.com/lei33440/chsrc/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/lei33440/chsrc/actions/workflows/shellcheck.yml)
[![Platform](https://img.shields.io/badge/platform-Linux-blue.svg)]()
[![Bash](https://img.shields.io/badge/bash-4.0%2B-green.svg)]()

[English](#english) | [中文](#中文)

---

## 中文

### 三个脚本，按需取用

| 脚本 | 作用 | 大小 |
|---|---|---|
| **`chsrc`** | 主菜单：换系统源 / 装 Docker / 配镜像 / 测速 / 备份还原（统一入口） | 约 50 KB |
| **`chsrc-lite`** | 极简换源器，无菜单，只接一个镜像名参数 | 约 12 KB |
| **`chsrc-docker`** | 独立的 Docker 安装 + registry-mirrors 配置器 | 约 14 KB |

三个脚本都自带 i18n（zh / en），互不依赖，可独立下载运行。

### 是什么

`chsrc` (change source) 是一个零依赖的单文件 Bash 脚本，自动识别当前 Linux 发行版，并把系统软件源切换为国内镜像，同时支持 Docker 一键安装与 registry-mirrors 配置。

- **单文件**：每个脚本都是一个独立文件，`curl | bash` 即用
- **零依赖**：纯 Bash + 系统自带工具（`curl`、`sed`、`gpg`），无需 Python/Ruby
- **自动识别**：通过 `/etc/os-release` 检测发行版与包管理器
- **场景化**：内置 `--cn`（国内云）/ `--edu`（教育网）/ `--abroad`（海外/官方）三种镜像集
- **安全**：换源前自动备份，写入失败可一键 `restore`
- **可逆**：`chsrc restore` / `chsrc-lite restore` 还原最近一次备份
- **可观测**：`--dry-run` 打印 diff 不写盘，`--verbose` 看每步执行

### 支持的发行版

| 包管理器 | 代表发行版 |
|---|---|
| **apt** | Debian / Ubuntu / Linux Mint / Kali / Deepin / Elementary / Zorin |
| **yum** | CentOS 7 / RHEL 7 |
| **dnf** | Fedora / RHEL 8+ / CentOS Stream / Rocky / AlmaLinux / openEuler / Anolis / OpenCloudOS |
| **pacman** | Arch / Manjaro / EndeavourOS / Garuda |
| **zypper** | openSUSE Leap / Tumbleweed / SLE |
| **apk** | Alpine / postmarketOS |
| **xbps** | Void |
| **eopkg** | Solus |
| **portage** | Gentoo |

### 支持的镜像源

**国内云**（`--cn`，默认）

- `aliyun` — 阿里云
- `huawei` — 华为云
- `tencent` — 腾讯云
- `163` — 网易
- `cmecloud` — 移动云
- `ctyun` — 天翼云
- `volces` — 火山引擎

**教育网**（`--edu`）

- `tuna` — 清华 TUNA
- `ustc` — 中科大 USTC
- `pku` — 北京大学
- `zju` — 浙江大学
- `nju` — 南京大学
- `sjtu` — 上海交大
- `hust` — 华中科大

**海外/官方**（`--abroad`）

- `official` — 上游官方（不修改）

### 快速开始

**一行命令直达 chsrc 菜单**（推荐，无需预装）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc | sudo bash
```

**一行 Docker 装机**（无菜单）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc-docker | sudo bash -s -- install aliyun
```

**一行换源**（无菜单，直接换到清华源）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc-lite | sudo bash -s -- tuna
```

**或者装到系统再跑**（`install.sh` 会一次装好三个脚本，并自动 exec chsrc）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash
```

`install.sh` 后面也可接子命令：

```bash
# 装三个脚本 + 执行 chsrc set tuna
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- set tuna

# 装三个脚本 + 执行 chsrc-lite tuna
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- chsrc-lite tuna

# 装三个脚本 + 执行 chsrc-docker install
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- chsrc-docker install aliyun

# 装三个脚本 + 执行 chsrc speedtest
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- speedtest
```

### chsrc — 主菜单交互

直接 `sudo chsrc` 即可进入主菜单，**自动识别系统**后编号选择功能：

```
=== chsrc v0.1.0 ===
  Ubuntu 24.04 LTS (noble)              apt / amd64 / ubuntu

主菜单
  1) 切换系统源
  2) 安装 Docker
  3) 配置 Docker 镜像加速
  4) 测速各镜像源
  5) 备份当前源
  6) 还原到备份
  7) 查看系统信息
  8) 退出
请选择 [1]:
```

选 1 后会再弹出镜像源菜单（按当前场景 `--cn/--edu/--abroad` 过滤）：

```
请选择镜像源 [cn]:
  1) 阿里云
  2) 华为云
  3) 腾讯云
  4) 网易
  5) 移动云
  6) 天翼云
  7) 火山引擎
请选择 [1]:
```

### chsrc 命令行模式（脚本/高级用户）

```bash
# 查看当前系统识别结果
chsrc status

# 交互式换源
sudo chsrc set

# 指定镜像直接换
sudo chsrc set tuna
sudo chsrc set aliyun --yes

# 仅打印将要做的改动
sudo chsrc set ustc --dry-run

# 选用教育网镜像集
sudo chsrc --edu set pku

# 测速各镜像源
sudo chsrc speedtest
sudo chsrc --abroad speedtest   # 只测 official

# 手动备份当前源
sudo chsrc backup

# 一键还原最近一次备份
sudo chsrc restore

# Docker 子命令
sudo chsrc docker install       # 默认用 aliyun 源
sudo chsrc docker install tuna
sudo chsrc docker mirror        # 写入 registry-mirrors
chsrc docker status             # 看状态

# 自更新到最新版本
sudo chsrc update
```

### chsrc-lite — 极简换源

适合脚本化场景：直接把镜像名作为位置参数，无菜单。

```bash
# 基本用法：chsrc-lite <mirror>
sudo chsrc-lite aliyun
sudo chsrc-lite tuna --yes
sudo chsrc-lite pku --edu --yes    # 限定教育网场景
sudo chsrc-lite official           # 不动（官方源）
sudo chsrc-lite aliyun --dry-run   # 只看 diff

# 还原
sudo chsrc-lite restore

# 全局选项
sudo chsrc-lite aliyun --verbose
sudo chsrc-lite aliyun --lang en
```

`chsrc-lite` 不包含 Docker 功能，不包含测速/菜单/状态/更新。镜像源列表和 `chsrc` 完全一致。

### chsrc-docker — Docker 装机专用

适合只想装 Docker / 配镜像加速、不想换系统源的用户。

```bash
# 交互菜单
sudo chsrc-docker

# 直接装（默认 aliyun）
sudo chsrc-docker install
sudo chsrc-docker install aliyun
sudo chsrc-docker install tuna
sudo chsrc-docker install official    # 用 download.docker.com
sudo chsrc-docker install aliyun --yes

# 写入 /etc/docker/daemon.json 的 registry-mirrors
sudo chsrc-docker mirror
sudo chsrc-docker mirror --yes

# 查看 Docker 与镜像状态
chsrc-docker status

# 帮助与版本
chsrc-docker help
chsrc-docker version
```

`docker mirror` 默认会写入这三个镜像：

- `https://docker.mirrors.aliyun.com`
- `https://mirror.ccs.tencentyun.com`
- `https://mirrors.huaweicloud.com/repository/docker`

写入方式是备份后覆盖 `/etc/docker/daemon.json`（会保留 `.bak.<timestamp>` 备份）。

### 全局选项

| 选项 | 说明 |
|---|---|
| `-y`, `--yes` | 非交互模式，跳过所有确认 |
| `--dry-run` | 只打印 diff，不实际写文件 |
| `--lang zh\|en` | 强制输出语言 |
| `--verbose` | 打印详细调试信息 |
| `--cn` | 选用国内云厂商镜像（默认场景） |
| `--edu` | 选用教育网镜像 |
| `--abroad` | 选用海外/上游官方 |
| `-h`, `--help` | 显示帮助 |

> `--cn/--edu/--abroad` 主要影响 `chsrc` 主菜单和 `chsrc-lite` 的场景校验；`chsrc-docker install <mirror>` 不受场景影响（你给什么镜像就用什么）。

### 备份与还原

每次换源前会创建带时间戳的备份：

- `/etc/apt/sources.list.bak.20260101120000`
- `/etc/yum.repos.d/CentOS-Base.repo.bak.20260101120000`
- …

并在 `/var/lib/chsrc/manifest` 记录 `<备份文件>\t<原文件>` 映射。`chsrc restore` / `chsrc-lite restore` 会从 manifest 反向读取，按原文件分组还原到最近一次备份。

> 备份文件不会被脚本删除，请定期手动清理 `*.bak.*` 文件。

### 常见问题

**Q: 换源后 apt update 报 GPG 错误？**
A: 切到不同镜像后发行版 GPG key 也需要替换。Debian/Ubuntu 通常会随换源自动重新拉取；如果是 apt-key 旧版残留，可手动 `apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <KEY>`。

**Q: 能否只测速不换源？**
A: `sudo chsrc speedtest`（主菜单选项 4 也能测速）。

**Q: chsrc / chsrc-lite / chsrc-docker 该用哪个？**
A:

- 第一次用、不知道选什么 → `chsrc`（带菜单）
- 写脚本、自动化部署 → `chsrc-lite <mirror>`
- 只想装 Docker / 配镜像加速 → `chsrc-docker`

**Q: chsrc 会删除我的备份吗？**
A: 不会，备份文件原地保留。

**Q: 是否支持 cross-arch（amd64 / arm64 / riscv64）？**
A: 是，arch 会被自动检测并写入对应仓库路径。

**Q: WSL 能不能用？**
A: 完全可以。

### 添加新发行版 / 镜像

PR 欢迎。每个脚本的核心位置：

- 系统识别 → `detect_system()` 在 `chsrc` / `chsrc-docker` / `chsrc-lite` 中
- 镜像 URL 映射 → `get_url_<pm>_<mirror>()` 一组函数
- 换源逻辑 → `write_<pm>()` 函数
- 备份/还原 → `backup_file()` / `restore_latest()`

### 致谢

- 各大镜像站（阿里云、清华 TUNA、中科大 USTC、华为云、腾讯云、网易、北大、浙大、南大、上交大、华科、移动云、天翼云、火山引擎）
- Bash 与 GNU coreutils
- [SuperManito/LinuxMirrors](https://github.com/SuperManito/LinuxMirrors) — UX 灵感来源

---

## English

### What is it

`chsrc` (change source) is a set of zero-dependency, single-file Bash scripts that auto-detect your Linux distribution and switch the system software source to a regional mirror of your choice. The set also bundles one-click Docker installation and `registry-mirrors` configuration.

- **Three scripts**:
  - `chsrc` — main entry with an interactive numbered menu
  - `chsrc-lite` — minimal CLI: `chsrc-lite <mirror>` with no menu
  - `chsrc-docker` — standalone Docker installer / mirror configurator
- **Zero deps** — pure Bash + system tools (`curl`, `sed`, `gpg`); no Python/Ruby
- **Auto-detect** — reads `/etc/os-release` to identify distro and package manager
- **Scenes** — `--cn` (China clouds), `--edu` (edu mirrors), `--abroad` (upstream official)
- **Safe** — automatic timestamped backup before any change, `restore` to revert
- **Observable** — `--dry-run` prints diff, `--verbose` logs every step

### Supported distros

| Package manager | Example distros |
|---|---|
| **apt** | Debian, Ubuntu, Linux Mint, Kali, Deepin, Elementary, Zorin |
| **yum** | CentOS 7, RHEL 7 |
| **dnf** | Fedora, RHEL 8+, CentOS Stream, Rocky, AlmaLinux, openEuler, Anolis, OpenCloudOS |
| **pacman** | Arch, Manjaro, EndeavourOS, Garuda |
| **zypper** | openSUSE Leap / Tumbleweed, SLE |
| **apk** | Alpine, postmarketOS |
| **xbps** | Void |
| **eopkg** | Solus |
| **portage** | Gentoo |

### Supported mirrors

**China clouds** (`--cn`, default)

- `aliyun`, `huawei`, `tencent`, `163`, `cmecloud`, `ctyun`, `volces`

**Edu** (`--edu`)

- `tuna`, `ustc`, `pku`, `zju`, `nju`, `sjtu`, `hust`

**Abroad/official** (`--abroad`)

- `official`

### Quick start

```bash
# Main menu (interactive)
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc | sudo bash

# One-line Docker install (Aliyun mirror)
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc-docker | sudo bash -s -- install aliyun

# One-line source switch (no menu)
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc-lite | sudo bash -s -- tuna

# Install all three scripts to /usr/local/bin
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash
```

### Examples — chsrc

```bash
chsrc status                       # Show detected system info
sudo chsrc set                     # Interactive switch
sudo chsrc set tuna                # Direct switch
sudo chsrc set aliyun --yes        # Non-interactive
sudo chsrc set ustc --dry-run      # Show what would be written
sudo chsrc --edu set pku           # Force edu scene
sudo chsrc speedtest               # Speed test all mirrors in current scene
sudo chsrc docker install          # Install Docker
sudo chsrc docker mirror           # Configure registry-mirrors
sudo chsrc restore                 # Restore the most recent backup
sudo chsrc update                  # Self-update
```

### Examples — chsrc-lite

```bash
sudo chsrc-lite aliyun             # Switch to aliyun
sudo chsrc-lite tuna --yes         # Non-interactive
sudo chsrc-lite pku --edu --yes    # Force edu scene
sudo chsrc-lite official           # No-op (use official)
sudo chsrc-lite restore            # Restore
sudo chsrc-lite aliyun --dry-run   # Show diff only
```

### Examples — chsrc-docker

```bash
sudo chsrc-docker                          # Interactive menu
sudo chsrc-docker install                  # Install (default: aliyun)
sudo chsrc-docker install tuna             # Use tuna mirror for docker-ce
sudo chsrc-docker install official         # Use download.docker.com
sudo chsrc-docker mirror                   # Configure registry-mirrors
chsrc-docker status                        # Show Docker version + mirrors
```

### Global options

| Flag | Description |
|---|---|
| `-y`, `--yes` | Non-interactive, accept all defaults |
| `--dry-run` | Print diff only, never write |
| `--lang zh\|en` | Force output language |
| `--verbose` | Verbose debug log |
| `--cn` / `--edu` / `--abroad` | Restrict mirror list to a scene |
| `-h`, `--help` | Show help |

### License

MIT — see [LICENSE](LICENSE).
