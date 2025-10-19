# WCD 一键出 PR（基于 GitHub App）

**一次配置，之后点按钮就能出 PR**：
1. 仓库 `Settings → Secrets → Actions` 新建：
   - `WCD_APP_ID`（GitHub App 的 App ID）
   - `WCD_APP_PRIVATE_KEY`（.pem 私钥全文）
2. 工作流：`Actions → WCD — One-shot PR → Run workflow`
3. 填 `filepath`、`content`、`title`（可选 `body`），回车。

---

## 参数建议
- `filepath`: 例如 `docs/wcd-sync/hello-from-bot.md`
- `content`: 普通文本，换行用 `\n`
- `title`: 例如 `WCD: bot sync — hello`
- `base`: 为空=默认分支
- `branch_prefix`: 默认为 `wcd-bot`

---

## 安全性
- 私钥仅保存在你仓库的 `Secrets` 里；工作流运行时临时换安装令牌
- 不暴露给外部服务；合规可审计

---

## 扩展
- 支持评论指令触发（追加另一个 workflow）
- 支持批量文件、自动合并（后续迭代）
