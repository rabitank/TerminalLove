#!/usr/bin/env bash
set -euo pipefail

# 获取脚本所在目录（绝对路径）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_DIR="$SCRIPT_DIR/engine"

# 检查 engine 目录是否存在且包含 Cargo.toml
if [[ ! -d "$ENGINE_DIR" ]]; then
    echo "❌ 错误：找不到 engine 目录（$ENGINE_DIR）"
    exit 1
fi
if [[ ! -f "$ENGINE_DIR/Cargo.toml" ]]; then
    echo "❌ 错误：engine 目录下没有 Cargo.toml，请确认 Rust 项目位置"
    exit 1
fi

echo "🔨 正在编译 engine 的 release 版本..."
cd "$ENGINE_DIR"
cargo build --release

# 确定可执行文件扩展名
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    EXE_EXT=".exe"
else
    EXE_EXT=""
fi

# 从 Cargo.toml 中获取包名（作为默认的可执行文件名）
PACKAGE_NAME=$(grep -m1 '^name = ' Cargo.toml | sed 's/name = "\(.*\)"/\1/' | tr -d '\r')
if [[ -z "$PACKAGE_NAME" ]]; then
    echo "⚠️ 无法从 Cargo.toml 解析包名，将使用 'engine' 作为可执行文件名"
    PACKAGE_NAME="engine"
fi

EXE_NAME="${PACKAGE_NAME}${EXE_EXT}"
SOURCE_PATH="$ENGINE_DIR/target/release/$EXE_NAME"
DEST_PATH="$SCRIPT_DIR/$EXE_NAME"

if [[ -f "$SOURCE_PATH" ]]; then
    cp "$SOURCE_PATH" "$DEST_PATH"
    echo "✅ 成功输出可执行文件到: $DEST_PATH"
else
    echo "❌ 未找到编译产物: $SOURCE_PATH"
    echo "   可能项目包含多个二进制目标，请手动检查 $ENGINE_DIR/target/release/ 目录"
    exit 1
fi
