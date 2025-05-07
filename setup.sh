#!/bin/bash

echo "🚀 HyperDisk 一键初始化脚本开始..."

# ------------------------
# 1. 定义挂载点
# ------------------------
VOLUMES=( "/Volumes/MacData" "/Volumes/SysLab" "/Volumes/VMStorage" )
SUBFOLDERS=(
  "MacData/iCloudSync" "MacData/Docs" "MacData/Projects"
  "SysLab/VMs" "SysLab/BootDisks" "SysLab/Scripts"
  "VMStorage/Cache" "VMStorage/TempData"
)

# ------------------------
# 2. 创建目录与 .gitkeep
# ------------------------
for path in "${SUBFOLDERS[@]}"; do
  full="/Volumes/$path"
  mkdir -p "$full"
  touch "$full/.gitkeep"
  echo "✅ 已创建: $full"
done

# ------------------------
# 3. 创建软链接到 ~/HyperDisk
# ------------------------
mkdir -p ~/HyperDisk
ln -sf /Volumes/MacData/Projects ~/HyperDisk/Projects
ln -sf /Volumes/MacData/Docs ~/HyperDisk/Docs
ln -sf /Volumes/SysLab/Scripts ~/HyperDisk/Scripts
ln -sf /Volumes/VMStorage/Cache ~/HyperDisk/Cache
echo "🔗 快捷访问目录已建立：~/HyperDisk"

# ------------------------
# 4. 检查 autorun.sh 是否存在
# ------------------------
SCRIPT_SRC="./autorun.sh"
SCRIPT_DST="/Volumes/MacData/Projects/hyperdisk-lab/autorun.sh"

if [ -f "$SCRIPT_SRC" ]; then
  cp "$SCRIPT_SRC" "$SCRIPT_DST"
  chmod +x "$SCRIPT_DST"
  echo "✅ autorun.sh 已部署到 $SCRIPT_DST"
else
  echo "⚠️ 请手动将 autorun.sh 放入项目目录"
fi

# ------------------------
# 5. 引导设置 launchd（可选）
# ------------------------
echo "🧩 如需实现 macOS 插盘自动运行 autorun.sh，请将 launchd plist 文件放入："
echo "→ ~/Library/LaunchAgents/com.hyperdisk.autorun.plist"
echo "并运行： launchctl load ~/Library/LaunchAgents/com.hyperdisk.autorun.plist"

echo "🎉 环境部署完成！"
