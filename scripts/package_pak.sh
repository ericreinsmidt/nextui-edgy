#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$PROJECT_DIR/dist"
PAK_JSON="$PROJECT_DIR/pak.json"

APP_NAME="$(grep -E '"name"' "$PAK_JSON" | head -n1 | cut -d'"' -f4)"

if [ -z "$APP_NAME" ]; then
    echo "ERROR: Failed to read name from pak.json"
    exit 1
fi

mkdir -p "$DIST_DIR"

for PLATFORM in tg5040 tg5050; do
    PAK_DIR="$PROJECT_DIR/ports/$PLATFORM/pak"

    if [ ! -f "$PAK_DIR/launch.sh" ]; then
        echo "Skipping $PLATFORM — no launch.sh"
        continue
    fi

    echo ""
    echo "=== Packaging ${APP_NAME} for ${PLATFORM} ==="
    echo ""

    TMP_DIR="$DIST_DIR/tmp-package"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    rsync -a --exclude='.DS_Store' "$PAK_DIR/" "$TMP_DIR/"

    OUTPUT_ZIP="$DIST_DIR/${APP_NAME}.${PLATFORM}.pak.zip"
    rm -f "$OUTPUT_ZIP"
    cd "$TMP_DIR"
    zip -r "$OUTPUT_ZIP" ./*
    cd "$PROJECT_DIR"
    rm -rf "$TMP_DIR"

    echo "Output: dist/${APP_NAME}.${PLATFORM}.pak.zip"
done

echo ""
echo "=== Done ==="
echo ""
