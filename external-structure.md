# External SSD Volume Structure (for Mac)

说明：本文件记录了挂载在 macOS 上的外部 SSD 目录结构，用于组织数据、开发、备份与虚拟机管理。

---

## /Volumes/MacData

| 文件夹        | 功能说明                                  |
|---------------|-------------------------------------------|
| iCloudSync/   | 轻量文件夹，用于与 iCloud Drive 同步           |
| Docs/         | 文档存放区，如说明文档、PDF、笔记、截图等         |
| Projects/     | Git 项目文件夹，示例：hyperdisk-lab 等开发项目目录 |

## /Volumes/SysLab

| 文件夹        | 功能说明                                      |
|-------------|---------------------------------------------|
| VMs/        | 存放虚拟机镜像（Parallels、UTM、VMware）等系统环境       |
| BootDisks/  | 启动盘映像文件，如 macOS 安装镜像、Linux ISO 等        |
| Scripts/    | 自动化脚本（如 autorun.sh）及系统相关配置脚本              |

## /Volumes/VMStorage

| 文件夹       | 功能说明                                |
|------------|---------------------------------------|
| Cache/     | 应用缓存目录，适用于视频剪辑、渲染等高读写场景       |
| TempData/  | 临时文件存储目录，处理大文件或转换任务用               |

---

## 使用建议

- 项目统一放在 `Projects/` 中，便于 Git 管理与 iCloud 备份。
- 大文件缓存或中间产物存入 `VMStorage/`，避免占用主系统磁盘。
- 自动化脚本统一放入 `SysLab/Scripts/`，支持 autorun 脚本执行。

> 建议将本结构作为 README 的一部分，便于多机共享与迁移。
