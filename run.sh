#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXE="$SCRIPT_DIR/tmj"
if [ ! -x "$EXE" ]; then
    echo "[错误] 找不到可执行文件: $EXE"
    exit 1
fi
exec "$EXE"
