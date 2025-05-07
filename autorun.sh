#!/bin/bash

echo "🔧 HyperDisk 初始化开始..."

# 挂载工作目录（可自动创建符号链接等）
mkdir -p ~/HyperDisk
ln -s "$(pwd)/MacData/Projects" ~/HyperDisk/Projects 2>/dev/null

echo "✅ 工作目录已准备好: ~/HyperDisk/Projects"
open ~/HyperDisk/Projects
