#!/usr/bin/env bash
# install.sh — Install chsrc to /usr/local/bin and launch it
# Usage:
#   curl -fsSL .../install.sh | sudo bash             # install + run menu
#   curl -fsSL .../install.sh | sudo bash -s -- set tuna   # install + run subcommand
#   curl -fsSL .../chsrc | sudo bash                   # one-shot, no install

set -e

REPO="${CHSRC_REPO:-lei33440/chsrc}"
BRANCH="${CHSRC_BRANCH:-main}"
INSTALL_DIR="${CHSRC_INSTALL_DIR:-/usr/local/bin}"
BIN_NAME="${CHSRC_BIN:-chsrc}"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/chsrc"

if [ "$(id -u)" -ne 0 ]; then
  echo "[!] 请用 root 或 sudo 执行本脚本"
  exit 1
fi

echo "[*] 下载 chsrc..."
tmp="$(mktemp)"
if ! curl -fsSL -o "${tmp}" "${RAW_URL}"; then
  echo "[x] 下载失败，请检查网络或访问 ${RAW_URL}"
  exit 1
fi

chmod +x "${tmp}"
install -m 755 "${tmp}" "${INSTALL_DIR}/${BIN_NAME}"
rm -f "${tmp}"

echo "[+] 已安装到 ${INSTALL_DIR}/${BIN_NAME}"
echo

# Auto-launch: hand off to the installed binary with any extra args the user passed.
# `exec` replaces this shell so the user sees chsrc's output directly, no nested prompt.
exec "${INSTALL_DIR}/${BIN_NAME}" "$@"
