#!/bin/bash

echo "🔌 HyperDisk 智能初始化中..."

MACDATA="/Volumes/MacData"
SYSLAB="/Volumes/SysLab"
VMSTORAGE="/Volumes/VMStorage"
SYNC_SCRIPT="$MACDATA/Projects/hyperdisk-lab/sync_macdata.sh"

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
# 创建别名快捷方式
# ------------------------
echo "🔗 检查 ~/HyperDisk 快捷目录..."
mkdir -p ~/HyperDisk
ln -sf "$MACDATA/Projects" ~/HyperDisk/Projects
ln -sf "$MACDATA/Docs" ~/HyperDisk/Docs
ln -sf "$SYSLAB/Scripts" ~/HyperDisk/Scripts
ln -sf "$VMSTORAGE/Cache" ~/HyperDisk/Cache

# ------------------------
# 定义通知函数
# ------------------------
function notify() {
  TITLE="$1"
  MESSAGE="$2"
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
}

# ------------------------
# 模式识别
# ------------------------
MODE=${1:-default} # 默认为 default 模式
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_DIR="$MACDATA/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/sync_$TIMESTAMP.log"

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

notify "HyperDisk" "模式 [$MODE] 执行完成，已自动挂载与初始化 ✅"
echo "✨ 初始化完成 [$MODE 模式]"
