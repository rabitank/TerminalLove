#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: $0 <version>}"
SUFFIX="${2:-}"
ENGINE_VER="${3:-latest}"

PACKAGE_NAME="TerminalLove-v${VERSION}${SUFFIX}"
STAGING="staging/${PACKAGE_NAME}"

if [ "$ENGINE_VER" = "latest" ]; then
    echo "==> Querying latest TermAVG release..."
    API_RESP=$(curl -fSL https://api.github.com/repos/rabitank/TermAVG/releases/latest)
    ENGINE_TAG=$(echo "$API_RESP" | grep -o '"tag_name": *"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"')
    if [ -z "$ENGINE_TAG" ]; then
        echo "ERROR: failed to parse latest TermAVG release tag" >&2
        exit 1
    fi
    ENGINE_VER="${ENGINE_TAG#v}"
    echo "==> TermAVG latest: ${ENGINE_TAG}"
else
    ENGINE_VER="${ENGINE_VER#v}"
fi

BASE_URL="https://github.com/rabitank/TermAVG/releases/download/v${ENGINE_VER}"

TMPDIR="engine_dl"
rm -rf "$TMPDIR"
mkdir -p "${TMPDIR}/tmj" "${TMPDIR}/wgpu"

echo "==> Downloading engine binaries (v${ENGINE_VER})..."
curl -fSL "${BASE_URL}/tmj-x86_64-unknown-linux-gnu-v${ENGINE_VER}.zip" -o "${TMPDIR}/tmj.zip"
curl -fSL "${BASE_URL}/tmj-wgpu-x86_64-unknown-linux-gnu-v${ENGINE_VER}.zip" -o "${TMPDIR}/wgpu.zip"

echo "==> Extracting..."
unzip -qo "${TMPDIR}/tmj.zip" -d "${TMPDIR}/tmj"
unzip -qo "${TMPDIR}/wgpu.zip" -d "${TMPDIR}/wgpu"

cp "${TMPDIR}/tmj/tmj_terminal" tmj
cp "${TMPDIR}/wgpu/tmj_wgpu" tmj_gui
cp "${TMPDIR}/tmj/LICENSE" engine_license.txt
rm -rf "$TMPDIR"

echo "==> Assembling ${PACKAGE_NAME}..."
rm -rf staging
mkdir -p "${STAGING}/resource" "${STAGING}/save"

cp tmj tmj_gui "${STAGING}/"
chmod +x "${STAGING}/tmj" "${STAGING}/tmj_gui"

cp run.sh "${STAGING}/"
chmod +x "${STAGING}/run.sh"
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

echo "==> Built target/artifacts/${PACKAGE_NAME}.zip"
