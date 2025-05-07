# 🚀 HyperDisk Lab

> 插盘即用的高性能外接 SSD 项目工作盘 + 自动化脚本系统。适用于多台 macOS 设备间的开发、备份、虚拟机运行等高级用途。

---

## 🔧 功能亮点

- 🧠 智能 `autorun.sh`：支持 dev / vm / backup 模式
- 🪄 插盘即运行：可通过 `launchd` 自动检测并触发脚本
- 🔁 自动同步：rsync 脚本将资料备份到本机
- 💻 虚拟机支持：一键加载 `.pvm` 或 `.utm` 系统镜像
- 🗂 快捷软链接：在 `~/HyperDisk/` 创建别名路径快速访问
- 🪧 macOS 通知：完成提示，状态可见
- 🧱 完善目录结构：用于文档、项目、系统、缓存等场景

---

## 📦 使用模式

```bash
./autorun.sh dev      # 打开项目 + 同步资料
./autorun.sh vm       # 启动虚拟机（.pvm / .utm）
./autorun.sh backup   # 仅执行数据同步
```

---

## 🧰 一键部署

首次在新设备运行：

```bash
chmod +x setup.sh
./setup.sh
```

它将自动创建目录、软链接、部署脚本、引导自动化配置。

---

## 📁 推荐目录结构

参考文档 👉 `external-structure.md`

```
/Volumes/MacData/
├── Projects/
├── Docs/
├── iCloudSync/
├── logs/

/Volumes/SysLab/
├── VMs/
├── Scripts/
├── BootDisks/

/Volumes/VMStorage/
├── Cache/
├── TempData/
```

---

## ⚙️ 插盘自动运行配置（macOS）

详见 👉 `docs/launchd-setup.md`：

```bash
cp launchd/com.hyperdisk.autorun.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.hyperdisk.autorun.plist
```

可选执行模式（dev/vm/backup）均支持。

---

## ☁️ GitHub Actions 自动打包

本项目自动在 `main` 和 `init-doc` 分支 push 时：

- 打包为 `hyperdisk-lab.zip`
- 发布为 GitHub Release（带唯一版本号）

配置文件见：`.github/workflows/release.yml`

---

## 📎 脚本说明

- `autorun.sh`：智能入口，挂载 + 同步 + 启动
- `setup.sh`：一键部署（目录 + 链接 + autorun）
- `sync_macdata.sh`：备份数据至本机
- `scripts/macdata-cleanup.sh`：清理误嵌套和占位符

---

## 📘 文档索引

- [`external-structure.md`](./external-structure.md)：分区与目录说明
- [`docs/launchd-setup.md`](./docs/launchd-setup.md)：自动运行配置指南

---

## 👤 作者

By [@arvingre](https://github.com/arvingre)

MIT License · Optimized for macOS · 可扩展至 Linux
