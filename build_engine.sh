#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_DIR="$SCRIPT_DIR/engine"

if [[ ! -d "$ENGINE_DIR" ]]; then
    echo "❌ 错误：找不到 engine 目录（$ENGINE_DIR）"
    exit 1
fi
if [[ ! -f "$ENGINE_DIR/Cargo.toml" ]]; then
    echo "❌ 错误：engine 目录下没有 Cargo.toml"
    exit 1
fi

echo "🔨 正在编译 release 版本..."
cd "$ENGINE_DIR"
cargo build --release -p tmj_terminal -p tmj_egui

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    EXE_EXT=".exe"
else
    EXE_EXT=""
fi

RELEASE_DIR="$ENGINE_DIR/target/release"
success=0

src="$RELEASE_DIR/tmj_terminal$EXE_EXT"
dst="$SCRIPT_DIR/tmj$EXE_EXT"
if [[ -f "$src" ]]; then
    cp "$src" "$dst"
    echo "✅ tmj_terminal$EXE_EXT -> tmj$EXE_EXT"
    success=$((success + 1))
else
    echo "❌ 未找到编译产物: $src"
fi

src="$RELEASE_DIR/tmj_egui$EXE_EXT"
dst="$SCRIPT_DIR/tmj_gui$EXE_EXT"
if [[ -f "$src" ]]; then
    cp "$src" "$dst"
    echo "✅ tmj_egui$EXE_EXT -> tmj_gui$EXE_EXT"
    success=$((success + 1))
else
    echo "❌ 未找到编译产物: $src"
fi

if [[ $success -eq 0 ]]; then
    echo "❌ 没有成功复制任何产物"
    exit 1
fi

echo "🎉 完成！产物已输出至: $SCRIPT_DIR"
