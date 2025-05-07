#!/bin/bash
echo "🔧 [macdata-cleanup] 开始清理 MacData..."

# 1. 清理异常嵌套目录
CLEAN_PATH="/Volumes/MacData/Projects/hyperdisk-lab/MacData"
if [ -d "$CLEAN_PATH" ]; then
  echo "🧹 删除嵌套目录: $CLEAN_PATH"
  rm -rf "$CLEAN_PATH"
fi

# 2. 补齐 .gitkeep 文件
echo "📁 确保空目录被 Git 跟踪"
touch /Volumes/MacData/iCloudSync/.gitkeep
touch /Volumes/MacData/Docs/.gitkeep
touch /Volumes/MacData/Projects/.gitkeep

# 3. 显示当前目录空间使用（排除系统隐藏目录）
echo "📊 当前空间占用（过滤系统目录）:"
du -sh /Volumes/MacData/* 2>/dev/null | grep -v -e '.Spotlight' -e '.fseventsd'

echo "✅ 清理完成"
