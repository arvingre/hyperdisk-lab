#!/bin/bash

echo "🔄 正在同步 MacData..."

SRC="./MacData/Projects/"
DEST=~/Documents/HyperBackup/Projects/

mkdir -p "$DEST"
rsync -avh --delete "$SRC" "$DEST"

echo "✅ 同步完成: $DEST"
