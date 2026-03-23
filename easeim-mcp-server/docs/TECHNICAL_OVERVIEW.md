# EaseIM MCP Server 技术文档

> 环信 IM SDK 开发助手 - 基于 MCP 协议的智能文档查询和源码搜索服务

## 目录

- [项目概述](#项目概述)
- [架构设计](#架构设计)
- [MCP 工具清单](#mcp-工具清单)
- [搜索引擎](#搜索引擎)
- [智能化模块](#智能化模块)
- [性能优化](#性能优化)
- [客户端配置](#客户端配置)
- [开发维护](#开发维护)

---

## 项目概述

### 定位

EaseIM MCP Server 是一个为环信 IM SDK 开发者设计的智能助手，通过 MCP (Model Context Protocol) 协议为 AI 客户端提供：

- **文档查询** - 闭源 SDK 的 API 文档、错误码、集成指南
- **源码搜索** - 开源 UIKit 组件的源码检索和定制方案
- **智能诊断** - 基于自然语言的问题诊断和解决方案
- **代码生成** - 常见开发场景的代码模板生成

### 技术栈

| 技术 | 说明 |
|------|------|
| 语言 | TypeScript |
| 运行时 | Node.js >= 18 |
| 协议 | MCP (Model Context Protocol) |
| SDK | @modelcontextprotocol/sdk |

### 当前平台覆盖（2026-03）

- 文档索引平台：`android`、`ios`、`web`、`rn`、`flutter`、`harmony`
- 源码索引平台：`android`、`ios`、`web`、`rn`、`flutter`、`harmony`
- 平台别名归一：
  - `harmonyos` / `ohos` → `harmony`
  - `react-native` / `reactnative` → `rn`

### 支持的客户端

| 客户端 | 支持方式 |
|--------|---------|
| Claude Code (CLI) | MCP 协议 |
| Claude Desktop | MCP 协议 |
| Cursor | MCP 协议 |
| VS Code + Continue | MCP 协议 |
| Xcode + GitHub Copilot | MCP 协议 |

---

## 架构设计

### 四层架构

```
┌─────────────────────────────────────────────────────────────────┐
│                         MCP 客户端                               │
│         (Claude Code / Cursor / VS Code / Xcode Copilot)        │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 │ MCP Protocol (stdio)
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                  MCP 工具层 (19 个工具，图中示意)                 │
│  ┌─────────────┬─────────────┬─────────────┬─────────────┐     │
│  │ lookup_error│ search_api  │search_source│ smart_assist│     │
│  ├─────────────┼─────────────┼─────────────┼─────────────┤     │
│  │ get_guide   │ diagnose    │ read_doc    │generate_code│     │
│  ├─────────────┼─────────────┼─────────────┼─────────────┤     │
│  │list_config  │get_extension│get_config   │explain_class│     │
│  │  _options   │  _points    │  _usage     │             │     │
│  └─────────────┴─────────────┴─────────────┴─────────────┘     │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                       智能化层 (P0 优化)                         │
│  ┌───────────────┬───────────────┬───────────────┐             │
│  │IntentClassifier│ QueryExpander │SimilarityMatcher│           │
│  │   意图分类      │  查询扩展      │   相似度匹配    │           │
│  ├───────────────┼───────────────┼───────────────┤             │
│  │KnowledgeGraph │ CodeGenerator │               │             │
│  │   知识图谱      │   代码生成     │               │             │
│  └───────────────┴───────────────┴───────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      搜索引擎层 (P1/P2 优化)                     │
│  ┌───────────────┬───────────────┬───────────────┐             │
│  │   DocSearch   │ SourceSearch  │ ConfigSearch  │             │
│  │   文档搜索     │   源码搜索     │   配置搜索    │             │
│  ├───────────────┼───────────────┼───────────────┤             │
│  │ InvertedIndex │ShardedSource  │AmbiguityDetector│           │
│  │   倒排索引     │  Search 分片   │   歧义检测    │             │
│  └───────────────┴───────────────┴───────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                         数据索引层                               │
│  ┌───────────────────────┬───────────────────────┐             │
│  │     docs/index.json   │   sources/manifest.json│            │
│  │     API 文档索引       │     源码分片清单        │            │
│  │     - apiModules      │   sources/shards/      │            │
│  │     - errorCodeIndex  │   ├── EaseChatUIKit.json│           │
│  │     - guides          │   ├── EaseCallUIKit.json│           │
│  │                       │   └── ...              │            │
│  └───────────────────────┴───────────────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

### 目录结构

```
easeim-mcp-server/
├── src/
│   ├── index.ts                    # 入口
│   ├── server.ts                   # MCP Server 实现
│   │
│   ├── tools/
│   │   └── index.ts                # 工具定义 (19 个工具)
│   │
│   ├── search/                     # 搜索引擎
│   │   ├── DocSearch.ts            # 文档搜索 (倒排索引 + BM25)
│   │   ├── SourceSearch.ts         # 源码搜索
│   │   ├── ShardedSourceSearch.ts  # 分片源码搜索 (P2)
│   │   ├── ConfigSearch.ts         # 配置搜索
│   │   ├── InvertedIndex.ts        # 倒排索引 (P1)
│   │   ├── AmbiguityDetector.ts    # 歧义检测
│   │   └── index.ts
│   │
│   ├── intelligence/               # 智能化模块
│   │   ├── IntentClassifier.ts     # 意图分类 (P0)
│   │   ├── QueryExpander.ts        # 查询扩展 (P0)
│   │   ├── SimilarityMatcher.ts    # 相似度匹配 (TF-IDF)
│   │   ├── KnowledgeGraph.ts       # 知识图谱
│   │   ├── CodeGenerator.ts        # 代码生成
│   │   └── index.ts
│   │
│   └── types/
│       └── index.ts                # 类型定义
│
├── data/
│   ├── docs/                       # SDK 文档
│   │   ├── index.json              # 文档索引
│   │   └── api/                    # API 文档 Markdown
│   │
│   └── sources/                    # UIKit 源码
│       ├── index.json              # 完整索引 (兼容)
│       ├── manifest.json           # 分片清单 (7KB)
│       └── shards/                 # 分片索引
│           ├── EaseChatUIKit.json
│           ├── EaseCallUIKit.json
│           ├── EaseChatroomUIKit.json
│           └── EaseChatDemo.json
│
├── scripts/
│   ├── generate-docs-index.ts      # 生成文档索引
│   ├── generate-doc-shards.ts      # 生成文档分片
│   ├── generate-source-index.ts    # 生成源码索引
│   ├── generate-source-shards.ts   # 生成源码分片
│   ├── replay-smart-assist-sessions.ts # 回放会话生成日志
│   ├── analyze-query-friction.ts   # 分析查询纠缠与证据链
│   └── analyze-config-impact.ts    # 分析配置影响
│
└── tests/
    ├── benchmark-search.ts         # 搜索性能测试
    └── benchmark-sharded-search.ts # 分片搜索测试
```

---

## MCP 工具清单

### 基础工具 (10 个)

| 工具名 | 功能 | 核心参数 |
|--------|------|----------|
| `lookup_error` | 查询错误码的含义、原因和解决方案 | `code: number` |
| `search_api` | 搜索 API 文档，支持平台/层级过滤 | `query`, `platform?`, `layer?` |
| `search_source` | 搜索 UIKit 源码，用于 UI 定制 | `query`, `component?` |
| `get_guide` | 获取集成指南 | `topic: quickstart\|login\|message\|...` |
| `diagnose` | 根据症状诊断错误原因 | `symptom: string` |
| `read_doc` | 读取完整文档内容 | `path: string` |
| `read_source` | 读取源码文件内容 | `path`, `startLine?`, `endLine?` |
| `list_config_options` | 列出 UIKit 配置项 | `component?` |
| `get_extension_points` | 获取可扩展的协议和类 | `component?`, `type?` |
| `get_config_usage` | 查询配置项使用详情 | `propertyName` |

### 智能化工具 (4 个)

| 工具名 | 功能 | 示例 |
|--------|------|------|
| `smart_assist` | 🧠 自然语言智能助手 | "我想自定义一个订单消息" |
| `generate_code` | 📝 代码模板生成 | `scenario="custom_message"` |
| `explain_class` | 📖 类用法解释 | `className="MessageCell"` |
| `list_scenarios` | 📋 开发场景列表 | `keyword="消息"` |

### 工具使用示例

```
# 查询错误码
lookup_error code=508

# 搜索 API (支持中英文)
search_api query="发送消息"
search_api query="sendMessage" platform="ios"

# 智能助手
smart_assist query="我想自定义一个订单消息类型"

# 生成代码
generate_code scenario="custom_message" name="Order"

# 搜索源码
search_source query="MessageBubble" component="EaseChatUIKit"
```

---

## 搜索引擎

### DocSearch (文档搜索)

**功能**: 搜索闭源 SDK 的 API 文档

**优化特性**:
- 倒排索引 + BM25 评分 (P1)
- 查询扩展 (90+ 同义词) (P0)
- 字段权重配置
- 平台/层级过滤

```typescript
// 搜索流程
Query → QueryExpander(同义词) → InvertedIndex(BM25) → Results
```

### SourceSearch / ShardedSourceSearch (源码搜索)

**功能**: 搜索开源 UIKit 组件源码

**优化特性**:
- 分片索引按需加载 (P2)
- LRU 缓存自动淘汰
- 驼峰命名拆分 (`MessageBubble` → `message bubble`)
- 并行搜索多个分片
- 符号级命中反推文件（提升 query → 文件命中率）
- 支持 `.dart` / `.ets` / `.tsx` / `.jsx` 参与索引

```typescript
// 分片结构
manifest.json (7KB) → 按需加载 → shards/EaseChatUIKit.json (827KB)
```

### InvertedIndex (倒排索引)

**功能**: O(k) 复杂度的高效搜索

**特性**:
- BM25 评分算法
- TF-IDF 加权
- 字段级权重配置
- 中英文混合分词 (单字 + Bigram + Trigram)

```typescript
// BM25 评分公式
score = IDF × (tf × (k1 + 1)) / (tf + k1 × (1 - b + b × (docLen / avgDocLen)))
```

### AmbiguityDetector (歧义检测)

**功能**: 检测跨平台/组件的歧义查询

**示例**:
```
Query: "sendMessage"
结果: iOS (3), Android (2), Web (2)
提示: "检测到跨平台结果，请指定 platform 参数"
```

---

## 查询纠缠与证据链分析

新增日志增强字段：

- `response.category`: `answer | clarification | no_result`
- `response.has_no_result_cue`
- `response.direct_no_result`
- `response.evidence_count`
- `response.preview`

新增脚本：

```bash
# 1) 回放会话并生成日志
EASEIM_SMART_ASSIST_LOG=1 \
EASEIM_SMART_ASSIST_LOG_PATH=./tmp/smart-assist.log \
npm run replay-smart-assist-sessions

# 2) 生成纠缠分析报告
npm run analyze-query-friction -- \
  --assist-log ./tmp/smart-assist.log \
  --output ./tmp/query-friction-report.md
```

报告会自动识别：

- 多轮纠缠问题（会话级 / 问题级）
- 原因归因（表述不清、内容缺失、未直接告知无结果、证据链弱）
- 对应优化建议与证据链样本

---

## 智能化模块

### IntentClassifier (意图分类)

**功能**: 理解用户自然语言意图

**支持的意图**:

| 意图 | 描述 | 示例 |
|------|------|------|
| `FIX_ERROR` | 修复错误 | "错误码 508 怎么解决" |
| `CUSTOMIZE_MESSAGE` | 自定义消息 | "我想添加一个订单消息" |
| `ADD_MENU_ITEM` | 添加菜单 | "如何添加发送位置的菜单" |
| `CUSTOMIZE_UI` | 定制 UI | "怎么修改气泡颜色" |
| `CONFIGURE_APPEARANCE` | 配置外观 | "如何设置主题色" |
| `UNDERSTAND_CLASS` | 理解类 | "MessageCell 是什么" |
| `INTEGRATE_SDK` | 集成 SDK | "如何集成 SDK" |
| `IMPLEMENT_FEATURE` | 实现功能 | "如何实现已读回执" |

**实体抽取** (P0 优化):
- 错误码: `错误码 508` → `errorCode: 508`
- 类名: `MessageCell` → `className: "MessageCell"`
- 组件: `EaseChatUIKit` → `componentName: "EaseChatUIKit"`
- 消息类型: `订单消息` → `messageName: "Order"`
- 配置项: `primaryHue` → `configProperty: "primaryHue"`

### QueryExpander (查询扩展)

**功能**: 同义词扩展提升召回率

**内置同义词库** (90+ 映射):

```typescript
// 示例映射
'消息' ↔ ['message', 'msg', '信息', '聊天']
'发送' ↔ ['send', '发', '推送', '传送']
'头像' ↔ ['avatar', '头像', '用户图片', 'profile']
'聊天室' ↔ ['chatroom', 'room', '直播间', '房间']
```

### KnowledgeGraph (知识图谱)

**功能**: 类关系和场景解决方案库

**包含**:
- 类继承关系
- 协议实现关系
- 常见开发场景的解决方案步骤
- 类的关键方法和属性说明

### CodeGenerator (代码生成)

**功能**: 根据场景生成 Swift 代码模板

**支持场景**:
- `custom_message` - 自定义消息类型
- `attachment_menu` - 添加附件菜单项
- `bubble_style` - 气泡样式定制
- `theme_config` - 主题配置
- `avatar_config` - 头像配置
- `long_press_menu` - 长按菜单

---

## 性能优化

### 优化路线图

| 优先级 | 优化项 | 状态 | 提升效果 |
|--------|--------|------|----------|
| P0 | 实体抽取增强 | ✅ | 提升意图识别准确率 |
| P0 | 查询扩展 (同义词) | ✅ | 召回率提升 30%+ |
| P1 | 倒排索引 + BM25 | ✅ | 搜索速度 37x 提升 |
| P1 | TF-IDF 加权 | ✅ | 排序相关性提升 |
| P2 | 源码索引分片 | ✅ | 首次加载 98% 更快 |

### 性能对比数据

#### 文档搜索 (DocSearch)

| 指标 | 优化前 | 优化后 |
|------|--------|--------|
| 搜索复杂度 | O(n) 全表扫描 | O(k) 词项查找 |
| 平均搜索耗时 | ~5ms | **0.086ms** |
| P95 延迟 | - | 0.218ms |

#### 源码搜索 (ShardedSourceSearch)

| 场景 | 全量搜索 | 分片搜索 | 提升 |
|------|----------|----------|------|
| 首次加载 (清单) | 23.65ms | 0.50ms | **98% 更快** |
| 单组件搜索 (缓存后) | 9.76ms | 0.26ms | **37x 更快** |
| 全组件搜索 (缓存后) | 9.76ms | 0.40ms | **24x 更快** |

### 分片索引结构

```
data/sources/
├── index.json           # 原始索引 (1.5MB) - 保留兼容
├── manifest.json        # 元数据清单 (7KB) ← 首次只加载这个
└── shards/
    ├── EaseChatUIKit.json      (827KB, 179 文件, 2417 符号)
    ├── EaseChatroomUIKit.json  (320KB, 81 文件, 936 符号)
    ├── EaseCallUIKit.json      (256KB, 66 文件, 801 符号)
    └── EaseChatDemo.json       (172KB, 53 文件, 541 符号)
```

---

## 客户端配置

### Claude Code / Claude Desktop

```json
// ~/.config/claude/claude_desktop_config.json
{
  "mcpServers": {
    "easeim": {
      "command": "npx",
      "args": ["-y", "easeim-mcp-server"]
    }
  }
}
```

### Cursor

```json
// .cursor/mcp.json
{
  "mcpServers": {
    "easeim": {
      "command": "npx",
      "args": ["-y", "easeim-mcp-server"]
    }
  }
}
```

### 本地开发

```bash
# 安装依赖
npm install

# 编译
npm run build

# 生成索引
npm run generate-all

# 生成分片索引
npx tsx scripts/generate-shards.ts

# 运行测试
npx tsx tests/benchmark-search.ts
npx tsx tests/benchmark-sharded-search.ts
```

---

## 开发维护

### 更新文档索引

```bash
# 更新 API 文档后重新生成索引
npm run generate-docs-index
```

### 更新源码索引

```bash
# 1. 下载/更新 UIKit 源码到 data/sources/ios/
# 2. 生成索引
npm run generate-source-index

# 3. 生成分片索引
npx tsx scripts/generate-shards.ts
```

### 添加新的 MCP 工具

1. 在 `src/tools/index.ts` 添加工具定义
2. 在 `src/server.ts` 添加处理器
3. 编译并测试

### 扩展同义词库

编辑 `src/intelligence/QueryExpander.ts`:

```typescript
private synonyms: Map<string, string[]> = new Map([
  ['新词', ['synonym1', 'synonym2', ...]],
  // ...
]);
```

---

## 技术亮点

1. **多层次搜索架构** - 文档、源码、配置三大搜索引擎独立优化
2. **智能意图理解** - 自然语言 → 意图分类 → 实体抽取 → 自动路由
3. **高性能倒排索引** - BM25 评分 + TF-IDF 加权 + 字段权重
4. **分片索引策略** - 按需加载 + LRU 缓存 + 并行搜索
5. **查询扩展** - 90+ 领域同义词 + 缩写展开 + 驼峰拆分
6. **歧义检测** - 自动检测跨平台/组件结果并提示用户

---

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0.0 | 2025-01 | 初始版本，基础工具实现 |
| 1.1.0 | 2025-01 | P0 优化：实体抽取、查询扩展 |
| 1.2.0 | 2025-01 | P1 优化：倒排索引、BM25 |
| 1.3.0 | 2025-01 | P2 优化：源码索引分片 |

---

## 联系方式

- **GitHub**: [easemob/easeim-mcp-server](https://github.com/easemob)
- **问题反馈**: Issues
- **环信官网**: https://www.easemob.com
