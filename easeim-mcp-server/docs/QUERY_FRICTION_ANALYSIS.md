# 查询纠缠分析指南

本指南用于自动识别“用户同一问题多次追问”的会话，并给出证据链报告。

## 0. 全平台分片刷新（推荐）

```bash
cd easeim-mcp-server
npm run generate-all-platform-shards
```

## 1. 生成测试日志（Smart Assist）

```bash
cd easeim-mcp-server
EASEIM_SMART_ASSIST_LOG=1 \
EASEIM_SMART_ASSIST_LOG_PATH="./tmp/smart-assist.log" \
npm run replay-smart-assist-sessions
```

可选：指定自定义会话用例文件（JSON 数组）

```bash
EASEIM_SMART_ASSIST_LOG=1 \
EASEIM_SMART_ASSIST_LOG_PATH="./tmp/smart-assist.log" \
npm run replay-smart-assist-sessions -- --cases "./tmp/my-sessions.json"
```

## 2. 分析纠缠问题

只分析 Smart Assist 日志：

```bash
npm run analyze-query-friction -- \
  --assist-log "./tmp/smart-assist.log" \
  --output "./tmp/query-friction-report.md"
```

同时分析 Tool + Smart Assist 日志：

```bash
npm run analyze-query-friction -- \
  --tool-log "./tmp/tool.log" \
  --assist-log "./tmp/smart-assist.log" \
  --output "./tmp/query-friction-report.md"
```

## 3. 报告内容

报告会输出：

- 纠缠问题 Top 列表（尝试次数、澄清次数、无结果次数）
- 归因结论：
  - 表述不清/缺少关键信息
  - 内容缺失/索引覆盖不足
  - 未直接告知无结果
  - 证据链偏弱（路径/行号不足）
- 逐条证据链（时间、路由、预览、证据命中）
- 查询优化建议
