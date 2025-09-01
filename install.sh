#!/bin/sh
# install.sh - Install fmtlog to /usr/local/bin

set -e

REPO_URL="https://raw.githubusercontent.com/mekariavre/fmtlog/main/fmtlog"
INSTALL_PATH="/usr/local/bin/fmtlog"

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root or with sudo: sudo sh install.sh" >&2
  exit 1
fi

curl -fsSL "$REPO_URL" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"
echo "fmtlog installed to $INSTALL_PATH"

