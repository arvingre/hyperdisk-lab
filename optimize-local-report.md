# 🧹 HyperDisk 本地空间优化记录

> 本文档记录了通过 `optimize_local_space.sh` 脚本将 macOS 中高占用的缓存与应用数据迁移到外接 SSD 的过程。

---

## 📦 迁移目标卷

**目标路径**：`/Volumes/VMStorage/Cache/`

请确保该 SSD 分区已正确挂载并预留足够空间。

---

## ✅ 已迁移目录列表

| 原始路径（主机） | 迁移目标（SSD） | 描述 |
|------------------|------------------|------|
| `~/Library/Containers/ru.keepcoder.Telegram` | `/VMStorage/Cache/Telegram/ru.keepcoder.Telegram` | Telegram 容器缓存 |
| `~/Library/Group Containers/6N38VWS5BX.ru.keepcoder.Telegram` | `/VMStorage/Cache/Telegram/6N38VWS5BX.ru.keepcoder.Telegram` | Telegram 聊天缓存 |
| `~/Library/Application Support/Code` | `/VMStorage/Cache/VSCodium/Code` | VS Code 配置缓存 |
| `~/Library/Application Support/Google` | `/VMStorage/Cache/Google` | Chrome 浏览器数据（缓存、扩展）|

---

## 🔁 操作方式

- 所有目录均使用 `mv` + `ln -s` 替代，确保系统路径无感知
- 建议操作前关闭相关 App，避免文件占用

---

## ⚠️ 注意事项

- Chrome 缓存迁移可能需要重新登录账号
- Telegram 可平稳迁移，但建议首次迁移后冷重启验证
- VS Code 的 `.vscode/extensions` 同步仍建议使用 GitHub 账户

---

## 📜 脚本来源

参见：[`scripts/optimize_local_space.sh`](./scripts/optimize_local_space.sh)

---
**更新于：** $(date "+%Y-%m-%d %H:%M")  
**作者：** [@arvingre](https://github.com/arvingre)
