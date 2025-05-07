#!/bin/bash

echo "🔌 HyperDisk 自动初始化中..."

# 定义关键挂载路径
MACDATA="/Volumes/MacData"
SYSLAB="/Volumes/SysLab"
VMSTORAGE="/Volumes/VMStorage"

# 1. 检查是否挂载成功
for VOLUME in "$MACDATA" "$SYSLAB" "$VMSTORAGE"; do
  if [ ! -d "$VOLUME" ]; then
    echo "⚠️ 未检测到卷: $VOLUME，请确认 SSD 是否正确挂载。"
    exit 1
  fi
done

echo "✅ 所有卷挂载正常"

# 2. 打开常用工作目录
open "$MACDATA/Projects"
open "$MACDATA/Docs"

# 3. 显示使用情况（简略）
echo "📊 当前卷空间占用："
df -h | grep '/Volumes/MacData\|/Volumes/SysLab\|/Volumes/VMStorage'

echo "✨ 初始化完成，欢迎回来！"
