#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: $0 <version>}"
SUFFIX="${2:-}"
ENGINE_VER="${3:-latest}"

PACKAGE_NAME="TerminalLove-v${VERSION}${SUFFIX}"
STAGING="staging/${PACKAGE_NAME}"

if [ "$ENGINE_VER" = "latest" ]; then
    ENGINE_TAG=$(curl -sL https://api.github.com/repos/rabitank/TermAVG/releases/latest | grep -o '"tag_name": *"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"')
    ENGINE_VER="${ENGINE_TAG#v}"
else
    ENGINE_VER="${ENGINE_VER#v}"
fi

BASE_URL="https://github.com/rabitank/TermAVG/releases/download/v${ENGINE_VER}"

TMPDIR="engine_dl"
rm -rf "$TMPDIR"
mkdir -p "${TMPDIR}/tmj" "${TMPDIR}/wgpu"

curl -sL "${BASE_URL}/tmj-x86_64-unknown-linux-gnu-v${ENGINE_VER}.zip" -o "${TMPDIR}/tmj.zip"
curl -sL "${BASE_URL}/tmj-wgpu-x86_64-unknown-linux-gnu-v${ENGINE_VER}.zip" -o "${TMPDIR}/wgpu.zip"

unzip -qo "${TMPDIR}/tmj.zip" -d "${TMPDIR}/tmj"
unzip -qo "${TMPDIR}/wgpu.zip" -d "${TMPDIR}/wgpu"

cp "${TMPDIR}/tmj/tmj_terminal" tmj
cp "${TMPDIR}/wgpu/tmj_wgpu" tmj_gui
cp "${TMPDIR}/tmj/LICENSE" engine_license.txt
rm -rf "$TMPDIR"

rm -rf staging
mkdir -p "${STAGING}/resource" "${STAGING}/save"

cp tmj tmj_gui "${STAGING}/"
cp setting.toml layout.toml game_setting.toml "${STAGING}/"
cp README.md "${STAGING}/"
cp engine_license.txt "${STAGING}/LICENSE"

cp -r resource/* "${STAGING}/resource/"

find "${STAGING}/resource" -type f \( -name '*.kra' -o -name '*.kra~' -o -name '*.aseprite' \) -delete
rm -rf "${STAGING}/resource/fc_old" "${STAGING}/resource/bxy_old" "${STAGING}/resource/fc_1" 2>/dev/null || true
rm -f "${STAGING}/resource/delete.fs" \
      "${STAGING}/resource/title_store.txt" \
      "${STAGING}/resource/需求说明.pdf" \
      "${STAGING}/resource/需求说明.zip" \
      "${STAGING}/resource/悬浮图片资源需求.md" 2>/dev/null || true

mkdir -p target/artifacts
cd staging
zip -r "../target/artifacts/${PACKAGE_NAME}.zip" "${PACKAGE_NAME}"
cd ..

rm -rf staging
rm -f tmj tmj_gui engine_license.txt

echo "Built target/artifacts/${PACKAGE_NAME}.zip"
