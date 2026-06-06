#!/usr/bin/env bash
# install.sh — Install chsrc, chsrc-docker, chsrc-lite to /usr/local/bin
# Usage:
#   curl -fsSL .../install.sh | sudo bash                    # install + run chsrc menu
#   curl -fsSL .../install.sh | sudo bash -s -- set tuna     # install + run chsrc set tuna
#   curl -fsSL .../chsrc | sudo bash                         # one-shot, no install
#   curl -fsSL .../chsrc-docker | sudo bash -s -- install    # one-shot Docker install
#   curl -fsSL .../chsrc-lite | sudo bash -s -- tuna         # one-shot source switch

set -e

REPO="${CHSRC_REPO:-lei33440/chsrc}"
BRANCH="${CHSRC_BRANCH:-main}"
INSTALL_DIR="${CHSRC_INSTALL_DIR:-/usr/local/bin}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

# Binaries to install. First one is what `exec` runs at the end (chsrc main).
BINS=(
  "chsrc"
  "chsrc-docker"
  "chsrc-lite"
)
# Default binary that exec launches when no subcommand provided.
DEFAULT_BIN="chsrc"

if [ "$(id -u)" -ne 0 ]; then
  echo "[!] 请用 root 或 sudo 执行本脚本"
  exit 1
fi

# First positional arg (after `--`) selects the binary to run.
# Examples:
#   install.sh                            -> exec chsrc
#   install.sh set tuna                   -> exec chsrc set tuna
#   install.sh docker install             -> exec chsrc docker install
#   install.sh chsrc-lite tuna            -> exec chsrc-lite tuna
#   install.sh chsrc-docker install tuna  -> exec chsrc-docker install tuna
TARGET_BIN="${DEFAULT_BIN}"
USER_ARGS=()
if [ $# -gt 0 ]; then
  case "$1" in
    chsrc|chsrc-docker|chsrc-lite)
      TARGET_BIN="$1"; shift ;;
  esac
  USER_ARGS=("$@")
fi

# Download and install all three scripts.
for bin in "${BINS[@]}"; do
  echo "[*] 下载 ${bin}..."
  tmp="$(mktemp)"
  if ! curl -fsSL -o "${tmp}" "${RAW_BASE}/${bin}"; then
    echo "[x] 下载失败: ${bin}  — 请检查网络或访问 ${RAW_BASE}/${bin}"
    rm -f "${tmp}"
    exit 1
  fi
  chmod +x "${tmp}"
  install -m 755 "${tmp}" "${INSTALL_DIR}/${bin}"
  rm -f "${tmp}"
  echo "[+] 已安装到 ${INSTALL_DIR}/${bin}"
done
echo

# Auto-launch: hand off to the chosen binary with the rest of the args.
exec "${INSTALL_DIR}/${TARGET_BIN}" "${USER_ARGS[@]}"
