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

### 是什么

`chsrc` (change source) 是一个零依赖的单文件 Bash 脚本，自动识别当前 Linux 发行版，并把系统软件源切换为国内镜像，同时支持 Docker 一键安装与 registry-mirrors 配置。

- **单文件**：一个 `chsrc` 文件包含全部功能，`curl | bash` 即用
- **零依赖**：纯 Bash + 系统自带工具（`curl`、`sed`、`gpg`），无需 Python/Ruby
- **自动识别**：通过 `/etc/os-release` 检测发行版与包管理器
- **安全**：换源前自动备份，写入失败可一键 `restore`
- **可逆**：`chsrc restore` 还原最近一次备份
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

- `aliyun` — 阿里云
- `tuna` — 清华 TUNA
- `ustc` — 中科大 USTC
- `huawei` — 华为云
- `tencent` — 腾讯云
- `163` — 网易
- `official` — 上游官方（不修改）

### 快速开始

**一行命令直达菜单**（推荐，无需预装）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc | sudo bash
```

**或者装到系统再跑**（`install.sh` 装完会自动 exec chsrc）：

```bash
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash
```

两种方式都直接进入主菜单，不需要再敲 `chsrc`。

**想直接传子命令**（不用进菜单）：

```bash
# 一行装并换 tuna 源
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- set tuna

# 一行测速
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash -s -- speedtest
```

### 主菜单交互

直接 `sudo chsrc` 即可进入主菜单，**自动识别系统**后编号选择功能：

```
=== chsrc v0.1.0 ===
检测到系统
  Ubuntu 24.04 LTS / apt / amd64

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

选 1 后会再弹出镜像源菜单：

```
请选择镜像源:
  1) 阿里云
  2) 清华 TUNA
  3) 中科大 USTC
  4) 华为云
  5) 腾讯云
  6) 网易
  7) 上游官方
请选择 [1]:
```

### 命令行模式（脚本/高级用户）

```bash

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

# 测速各镜像源
sudo chsrc speedtest

# 手动备份当前源
sudo chsrc backup

# 一键还原最近一次备份
sudo chsrc restore

# 安装 Docker
sudo chsrc docker install

# 配置 Docker 镜像加速
sudo chsrc docker mirror

# 查看 Docker 与镜像状态
chsrc docker status

# 自更新到最新版本
sudo chsrc update
```

### Docker 子命令

```bash
# 装 Docker，自动选当前系统对应的包管理器
sudo chsrc docker install

# 装 Docker 时指定安装源（official / aliyun）
sudo chsrc docker install official

# 配置 registry-mirrors 到 /etc/docker/daemon.json
sudo chsrc docker mirror

# 查看 docker info 中的 Registry Mirrors 段
chsrc docker status
```

`docker mirror` 默认会写入这三个镜像：

- `https://docker.mirrors.aliyun.com`
- `https://mirror.ccs.tencentyun.com`
- `https://mirrors.huaweicloud.com/repository/docker`

写入方式是合并到现有 `/etc/docker/daemon.json`（通过 Python `json.tool` 或 jq 合并，不直接覆盖用户已有配置）。

### 全局选项

| 选项 | 说明 |
|---|---|
| `-y`, `--yes` | 非交互模式，跳过所有确认 |
| `--dry-run` | 只打印 diff，不实际写文件 |
| `--lang zh\|en` | 强制输出语言 |
| `--verbose` | 打印详细调试信息 |
| `-h`, `--help` | 显示帮助 |

### 备份与还原

每次换源前会创建带时间戳的备份：

- `/etc/apt/sources.list.bak.20260101120000`
- `/etc/yum.repos.d/CentOS-Base.repo.bak.20260101120000`
- …

并在 `/var/lib/chsrc/manifest` 记录 `<备份文件>\t<原文件>` 映射。`chsrc restore` 会从 manifest 反向读取，按原文件分组还原到最近一次备份。

> 备份文件不会被脚本删除，请定期手动清理 `*.bak.*` 文件。

### 常见问题

**Q: 换源后 apt update 报 GPG 错误？**
A: 切到不同镜像后发行版 GPG key 也需要替换。Debian/Ubuntu 通常会随换源自动重新拉取；如果是 apt-key 旧版残留，可手动 `apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <KEY>`。

**Q: 能否只测速不换源？**
A: `sudo chsrc speedtest`。

**Q: chsrc 会删除我的备份吗？**
A: 不会，备份文件原地保留。

**Q: 是否支持 cross-arch（amd64 / arm64 / riscv64）？**
A: 是，arch 会被自动检测并写入对应仓库路径。

**Q: WSL 能不能用？**
A: 完全可以。

### 添加新发行版 / 镜像

PR 欢迎。核心位置：

- 系统识别 → `detect_system()` 在 `chsrc` 脚本中
- 镜像 URL 映射 → `get_url_<pm>_<mirror>()` 一组函数
- 换源逻辑 → `write_<pm>()` 函数
- 备份/还原 → `backup_file()` / `restore_latest()`

### 致谢

- 各大镜像站（阿里云、清华 TUNA、中科大 USTC、华为云、腾讯云、网易）
- Bash 与 GNU coreutils

---

## English

### What is it

`chsrc` (change source) is a zero-dependency, single-file Bash script that auto-detects your Linux distribution and switches the system software source to a regional mirror of your choice. It also bundles one-click Docker installation and `registry-mirrors` configuration.

- **Single file** — everything in one `chsrc`, runnable via `curl | bash`
- **Zero deps** — pure Bash + system tools (`curl`, `sed`, `gpg`); no Python/Ruby
- **Auto-detect** — reads `/etc/os-release` to identify distro and package manager
- **Safe** — automatic timestamped backup before any change, `restore` to revert
- **Reversible** — `chsrc restore` reverts to the most recent backup
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

- `aliyun` — Aliyun
- `tuna` — Tsinghua TUNA
- `ustc` — USTC
- `huawei` — Huawei Cloud
- `tencent` — Tencent Cloud
- `163` — NetEase
- `official` — upstream (no changes)

### Quick start

```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/install.sh | sudo bash

# Or run directly without installing
curl -fsSL https://raw.githubusercontent.com/lei33440/chsrc/main/chsrc | sudo bash -s -- status
```

### Examples

```bash
# Show detected system info
chsrc status

# Interactive switch
sudo chsrc set

# Direct switch with a specific mirror
sudo chsrc set tuna
sudo chsrc set aliyun --yes

# Show what would be written
sudo chsrc set ustc --dry-run

# Speed test all mirrors
sudo chsrc speedtest

# Manual backup
sudo chsrc backup

# Restore the most recent backup
sudo chsrc restore

# Install Docker
sudo chsrc docker install

# Configure Docker registry mirrors
sudo chsrc docker mirror

# Self-update
sudo chsrc update
```

### Global options

| Flag | Description |
|---|---|
| `-y`, `--yes` | Non-interactive, accept all defaults |
| `--dry-run` | Print diff only, never write |
| `--lang zh\|en` | Force output language |
| `--verbose` | Verbose debug log |
| `-h`, `--help` | Show help |

### License

MIT — see [LICENSE](LICENSE).
