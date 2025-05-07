#!/bin/bash

echo "🔌 HyperDisk 智能初始化中..."

MACDATA="/Volumes/MacData"
SYSLAB="/Volumes/SysLab"
VMSTORAGE="/Volumes/VMStorage"
SYNC_SCRIPT="$MACDATA/Projects/hyperdisk-lab/sync_macdata.sh"
LOG_FILE="$MACDATA/sync.log"

# ------------------------
# 检查挂载卷
# ------------------------
for VOLUME in "$MACDATA" "$SYSLAB" "$VMSTORAGE"; do
  if [ ! -d "$VOLUME" ]; then
    echo "❌ 未找到 $VOLUME，请确认挂载。"
    exit 1
  fi
done
echo "✅ 所有卷已挂载"

# ------------------------
# 模式识别
# ------------------------
MODE=${1:-default} # 默认为 default 模式

case "$MODE" in
  dev)
    echo "🧪 [开发模式] 启动中..."
    open "$MACDATA/Projects"
    open "$MACDATA/Docs"
    [ -f "$SYNC_SCRIPT" ] && bash "$SYNC_SCRIPT" >> "$LOG_FILE" 2>&1
    ;;
  vm)
    echo "💻 [虚拟机模式] 启动中..."
    VM_DIR="$SYSLAB/VMs"
    VM_LAUNCHED=false
    for vmfile in "$VM_DIR"/*.pvm "$VM_DIR"/*.utm; do
      if [ -f "$vmfile" ]; then
        echo "🚀 启动虚拟机: $vmfile"
        open "$vmfile"
        VM_LAUNCHED=true
        break
      fi
    done
    if [ "$VM_LAUNCHED" = false ]; then
      echo "⚠️ 未找到可用虚拟机镜像"
    fi
    ;;
  backup)
    echo "🧩 [备份模式] 执行同步..."
    [ -f "$SYNC_SCRIPT" ] && bash "$SYNC_SCRIPT" >> "$LOG_FILE" 2>&1
    ;;
  *)
    echo "🔁 [默认模式] 打开工作目录 + 显示用量"
    open "$MACDATA/Projects"
    open "$MACDATA/Docs"
    df -h | grep '/Volumes/MacData\|/Volumes/SysLab\|/Volumes/VMStorage'
    ;;
esac

echo "✨ 初始化完成 [$MODE 模式]"
