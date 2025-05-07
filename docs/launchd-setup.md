# ⚙️ 插盘自动运行配置指南（macOS Launchd）

> 本文档说明如何在 macOS 中配置 launchd，使外接 SSD 插入后自动运行 autorun.sh 脚本。

---

## ✅ 步骤 1：创建 LaunchAgent 配置文件

在终端中执行以下命令，创建并编辑配置文件：

```bash
mkdir -p ~/Library/LaunchAgents
nano ~/Library/LaunchAgents/com.hyperdisk.autorun.plist
```

将以下内容粘贴进去（确保路径正确）：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.hyperdisk.autorun</string>

  <key>ProgramArguments</key>
  <array>
    <string>/Volumes/MacData/Projects/hyperdisk-lab/autorun.sh</string>
    <string>dev</string>
  </array>

  <key>WatchPaths</key>
  <array>
    <string>/Volumes/MacData</string>
  </array>

  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
```

---

## ✅ 步骤 2：加载启动项

在终端执行：

```bash
launchctl load ~/Library/LaunchAgents/com.hyperdisk.autorun.plist
```

可通过以下命令确认是否加载成功：

```bash
launchctl list | grep hyperdisk
```

---

## ❌ 卸载方法

若需要停止自动运行：

```bash
launchctl unload ~/Library/LaunchAgents/com.hyperdisk.autorun.plist
```

---

## 📌 说明

- 插入 SSD 并挂载 `/Volumes/MacData` 后，脚本将自动以 `dev` 模式执行
- 可将 `dev` 改为 `vm`、`backup` 等模式
- 支持所有 Apple Silicon 与 Intel 架构的 macOS 10.15+

