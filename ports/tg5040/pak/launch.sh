#!/bin/sh
# Toggles between squared and stock pill sprites

PAK_DIR="$(dirname "$0")"
RES_DIR="/mnt/SDCARD/.system/res"
BACKUP_DIR="/mnt/SDCARD/.userdata/shared/edgy_backup"

if [ -d "$BACKUP_DIR" ]; then
    # Restore originals
    for scale in 1 2 3 4; do
        src="$BACKUP_DIR/assets@${scale}x.png"
        dst="$RES_DIR/assets@${scale}x.png"
        [ -f "$src" ] && cp "$src" "$dst"
    done
    rm -rf "$BACKUP_DIR"
else
    # Backup originals then apply
    mkdir -p "$BACKUP_DIR"
    for scale in 1 2 3 4; do
        cp "$RES_DIR/assets@${scale}x.png" "$BACKUP_DIR/" 2>/dev/null
        cp "$PAK_DIR/res/assets@${scale}x.png" "$RES_DIR/" 2>/dev/null
    done
fi
