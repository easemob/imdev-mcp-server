# raw-materials 目录结构与文件要求

## 目录结构概览

```
raw-materials/
├── docs/
│   ├── ios/
│   ├── android/
│   ├── web/
│   ├── rn/
│   ├── flutter/
│   ├── harmonyos/       (索引内归一为 harmony)
│   └── ...
└── sources/
    ├── ios/
    ├── android/
    ├── web/
    ├── rn/
    ├── flutter/
    ├── harmonyos/       (索引内归一为 harmony)
    └── ...
```

---

## 1. 文档要求 (docs/)

### 目录结构

```
raw-materials/docs/<platform>/
├── api/                    # SDK API 文档
│   ├── connection.md
│   ├── login.md
│   ├── message_send.md
│   ├── group_manage.md
│   └── ...
├── guides/                 # 开发指南
│   └── <product>/
│       ├── chatuikit/
│       │   ├── README.md
│       │   ├── quickstart.md
│       │   ├── installation.md
│       │   └── ...
│       ├── callkit/
│       │   ├── README.md
│       │   └── ...
│       └── sdk/
│           ├── integration.md
│           └── ...
└── errors/                 # 错误码文档 (可选)
    └── error_codes.md
```

### 文件格式要求

#### 1. Markdown 格式 (.md)

**必须项**:
- 文件编码: **UTF-8**
- 换行符: **LF** (Unix 风格，不要 CRLF)

#### 2. 标题和元数据

**脚本依据文件的第一个 `# 标题` 提取**:

```markdown
# API Module Name  ← 自动作为 title
Some description text here  ← 自动作为 description
```

脚本处理逻辑:
- 找到第一个 `# ...` 作为 title
- 找到第一个非空、非 # 开头的行作为 description
- 如果找不到会使用文件名作为 title

#### 3. 错误码表格格式

**location**: `raw-materials/docs/<platform>/errors/error_codes.md`

**表格结构** (必须严格遵循):

```markdown
| 错误码 | 错误信息 | 描述和可能原因 | 解决方法 |
| :-: | :-: | :-: | :-: |
| 508 | CONNECTION_FAIL | 连接失败：网络问题 | 检查网络连接 |
| 509 | AUTH_FAIL | 认证失败：密码错误 | 检查账号密码 |
```

**必须项**:
- 第一行: `| 错误码 | 错误信息 | 描述和可能原因 | 解决方法 |`
- 第二行: `| :-: | :-: | :-: | :-: |`
- 之后的行: `| <number> | <name> | <description> | <solution> |`

**提取规则**:
- 错误码: 第一列，自动转为 int
- 错误信息: 第二列（名称）
- 描述: 第三列，支持多行（用 `<br>` 或 `<br/>` 分隔）
- 解决方案: 第四列，支持多行

#### 4. 产品识别

脚本根据路径自动识别产品 (product):

```typescript
if (path.includes('callkit'))        → product = 'callkit'
if (path.includes('chatroomuikit'))  → product = 'chatroomuikit'
if (path.includes('chatuikit'))      → product = 'chatuikit'
if (path.includes('imkit'))          → product = 'imkit'
if (path.includes('sdk'))            → product = 'sdk'
else                                 → product = 'general'
```

> 说明：`chatroomuikit` 判断优先级高于 `chatuikit`，避免路径中同时包含 `uikit` 时误归类。

### 示例结构

```
raw-materials/docs/ios/
├── api/
│   ├── connection.md
│   │   # Connection Management
│   │   Manage connection to Hyphenate servers
│   │
│   ├── login.md
│   ├── message_send.md
│   └── message_receive.md
├── guides/
│   ├── sdk/
│   │   ├── integration.md
│   │   │   # Integration Guide
│   │   │   Step-by-step guide to integrate HyphenateChat SDK
│   │   │
│   │   └── quickstart.md
│   └── chatuikit/
│       ├── README.md
│       ├── customization.md
│       └── theme.md
└── errors/
    └── error_codes.md
        | 错误码 | 错误信息 | 描述... |
        | :-: | :-: | :-: |
        | 508 | ... |
```

---

## 2. 源码要求 (sources/)

### 目录结构

```
raw-materials/sources/<platform>/
├── <ComponentName>/
│   ├── Classes/       # 或其他源码目录
│   │   ├── *.swift    (iOS)
│   │   ├── *.kt       (Android)
│   │   └── *.tsx      (Web)
│   └── ...
└── <AnotherComponent>/
    └── ...
```

### 支持的文件类型

| 平台 | 文件扩展名 | 备注 |
|------|----------|------|
| iOS | `.swift` | Swift 源码，支持 class/struct/protocol/enum/func/var/let 解析 |
| Android | `.java`、`.kt` | Java/Kotlin，支持 class/method/field 解析 |
| Web | `.tsx`、`.ts`、`.jsx`、`.js` | TypeScript/JavaScript |
| React Native | `.tsx`、`.ts`、`.jsx`、`.js` | TypeScript/JavaScript |
| Flutter | `.dart` | Dart 源码，支持 class/method/property 基础解析 |
| HarmonyOS | `.ets` | ArkTS/ETS 源码，支持 class/interface/method/property 基础解析 |

### 代码符号解析

#### iOS (Swift)

脚本自动提取以下符号:

```swift
// 1. 类/结构体/协议/枚举
class MessageCell { }
struct ChatViewModel { }
protocol ChatUIKitDelegate { }
enum MessageType { }

// 2. 方法
func sendMessage(text: String) -> Void

// 3. 初始化
init(frame: CGRect)

// 4. 属性
var delegate: ChatDelegate?
let maxLength: Int = 100
```

**文档注释格式** (可选但推荐):

```swift
/// Single-line doc comment
func simpleMethod() { }

/**
 Multi-line block comment
 with multiple lines
 */
class MyClass { }

// Regular comments (not extracted)
func notDocumented() { }
```

**提取规则**:
- 支持 `///` 和 `/** */` 注释提取
- 提取签名(signature)和参数类型
- 提取所属的 class/struct/protocol (owner)
- 记录起止行号 (startLine/endLine)

#### Android (Java/Kotlin)

已支持基础解析:

```java
// Java
public class ChatActivity extends Activity {
    private ChatManager chatManager;
    
    public void sendMessage(String msg) { }
}

// Kotlin
class ChatScreen : Composable {
    var message: String = ""
    
    fun sendMessage(text: String) { }
}
```

#### Web/React Native (TypeScript/JavaScript)

已支持基础解析（含 `.ts/.tsx/.js/.jsx`）。

#### Flutter (Dart)

已支持基础解析（含 `.dart`）。

#### HarmonyOS (ETS/ArkTS)

已支持基础解析（含 `.ets`）。

### 平台命名归一

索引侧会自动归一平台命名：

- `harmonyos` / `ohos` → `harmony`
- `react-native` / `reactnative` → `rn`

### 性能考虑

**文件规模**:
- 单个组件源码通常 200KB-1MB
- 脚本会自动分片处理大型源码集
- LRU 缓存按需加载，避免内存溢出

### 示例结构

```
raw-materials/sources/ios/
├── EaseChatUIKit/
│   └── Classes/
│       ├── Core/
│       │   ├── ChatUIManager.swift
│       │   └── ...
│       ├── UI/
│       │   ├── MessageCell.swift
│       │   ├── ConversationListViewController.swift
│       │   └── ...
│       └── Service/
│           └── ...
├── EaseCallUIKit/
│   └── Classes/
│       ├── CommonUI/
│       ├── Calling/
│       └── ...
└── EaseChatDemo/
    ├── LoginViewController.swift
    ├── Main/
    └── Utils/
```

---

## 3. 索引生成流程

### 文档索引生成

```bash
npm run generate-docs-index
```

**输出**: `data/docs/index.json`

**处理流程**:
1. 遍历 `raw-materials/docs/<platform>/` 下的所有 `.md` 文件
2. 提取 `# 标题` 和第一行描述
3. 自动识别产品类型 (product)
4. 生成 **guides** 和 **apiModules** 索引
5. 解析错误码表格到 **errorCodeIndex**
6. **同时复制所有文档文件** 到 `data/docs/`

```json
{
  "version": "3.0.0",
  "platforms": ["ios", "android", "web", "rn", "flutter", "harmony"],
  "guides": [
    {
      "id": "ios_sdk_integration",
      "title": "Integration Guide",
      "path": "ios/guides/sdk/integration.md",
      "platform": "ios",
      "product": "sdk",
      "keywords": ["ios", "Integration Guide"],
      "description": "Step-by-step guide to integrate..."
    }
  ],
  "apiModules": [
    {
      "id": "ios_connection",
      "name": "Connection Management",
      "docPath": "ios/api/connection.md",
      "platform": "ios",
      "product": "sdk",
      "description": "Manage connection to servers"
    }
  ],
  "errorCodeIndex": {
    "508": {
      "code": 508,
      "name": "CONNECTION_FAIL",
      "brief": "连接失败",
      "description": "连接失败：网络问题",
      "causes": ["网络问题"],
      "solutions": ["检查网络连接"]
    }
  }
}
```

### 源码索引生成

```bash
npm run generate-source-index
```

**输出**: `data/sources/index.json` (完整索引) 和分片

**处理流程**:
1. 遍历 `raw-materials/sources/<platform>/` 下的源码文件
2. 按文件类型解析符号 (Swift/Java/Kotlin)
3. 提取类、方法、属性及其文档注释
4. 生成完整索引到 `data/sources/index.json`

```json
{
  "version": "2.0.0",
  "platforms": ["ios", "android"],
  "files": [
    {
      "path": "ios/EaseChatUIKit/Classes/Core/ChatUIManager.swift",
      "platform": "ios",
      "component": "EaseChatUIKit",
      "classes": ["ChatUIManager"],
      "lines": 450
    }
  ],
  "symbols": [
    {
      "name": "ChatUIManager",
      "type": "class",
      "file": "ios/EaseChatUIKit/Classes/Core/ChatUIManager.swift",
      "line": 12,
      "startLine": 12,
      "endLine": 462,
      "signature": "public class ChatUIManager",
      "description": "Core manager for chat UI",
      "doc": "...",
      "platform": "ios",
      "component": "EaseChatUIKit"
    },
    {
      "name": "setupUI",
      "type": "func",
      "file": "ios/EaseChatUIKit/Classes/Core/ChatUIManager.swift",
      "line": 45,
      "startLine": 45,
      "endLine": 120,
      "signature": "func setupUI()",
      "owner": "ChatUIManager",
      "params": [],
      "description": "Setup UI components",
      "platform": "ios",
      "component": "EaseChatUIKit"
    }
  ]
}
```

---

## 4. 检查清单

### 添加新平台前

- [ ] 准备文档目录结构: `raw-materials/docs/<platform>/` (包含 api/, guides/, 可选 errors/)
- [ ] 准备源码目录结构: `raw-materials/sources/<platform>/` (包含组件子目录)
- [ ] 确保所有 Markdown 文件编码为 UTF-8，换行符为 LF
- [ ] 确保所有源码文件编码正确，支持该语言的文件类型
- [ ] 运行 `npm run generate-docs-index` 生成文档索引
- [ ] 运行 `npm run generate-source-index` 生成源码索引
- [ ] 运行 `npm run generate-shards.ts` 生成分片索引 (可选，用于性能优化)
- [ ] 编辑 `data/platforms/index.json` 添加平台入口路由
- [ ] 测试搜索和诊断功能

### 文件内容检查

**文档**:
- [ ] 第一行是 `# 标题` (脚本自动提取)
- [ ] 第二行是描述文本 (非 #、非空)
- [ ] 错误码表格格式正确 (4 列，第二行是分隔符)
- [ ] 没有特殊字符或编码问题

**源码**:
- [ ] 所有 class/struct/protocol/func 有正确的缩进
- [ ] 文档注释使用 `///` 或 `/** */` (Swift)
- [ ] 参数列表完整，方便签名解析
- [ ] 类方法能识别所属类 (owner)

---

## 5. 故障排查

### 索引生成失败

```bash
# 检查目录是否存在
ls -la raw-materials/docs/
ls -la raw-materials/sources/

# 重新生成，查看详细日志
npm run generate-docs-index 2>&1 | tail -50
npm run generate-source-index 2>&1 | tail -50
```

### 文档搜索无结果

1. 检查文档是否被复制到 `data/docs/`
   ```bash
   ls -la data/docs/ios/
   ```

2. 检查索引文件 `data/docs/index.json` 是否包含该文档
   ```bash
   cat data/docs/index.json | grep "search_keyword"
   ```

### 源码搜索无结果

1. 检查源码是否被索引
   ```bash
   cat data/sources/index.json | grep "ClassName"
   ```

2. 检查符号是否正确解析
   ```bash
   # 查看某个文件的所有符号
   cat data/sources/index.json | jq '.symbols[] | select(.file == "ios/...")'
   ```

### 错误码查询空

1. 检查错误码是否被解析
   ```bash
   cat data/docs/index.json | jq '.errorCodeIndex | keys'
   ```

2. 检查表格格式 (必须 4 列，用 | 分隔)

---

## 6. 扩展新平台的完整步骤

以 **React Native** 为例:

### Step 1: 准备文档

```bash
mkdir -p raw-materials/docs/rn/api
mkdir -p raw-materials/docs/rn/guides/chatuikit
mkdir -p raw-materials/docs/rn/guides/sdk
mkdir -p raw-materials/docs/rn/errors

# 将文档文件放入对应目录
cp <your-rn-docs>/*.md raw-materials/docs/rn/api/
cp <your-rn-guides>/*.md raw-materials/docs/rn/guides/sdk/
```

### Step 2: 准备源码

```bash
mkdir -p raw-materials/sources/rn/EaseChatUIKit
mkdir -p raw-materials/sources/rn/EaseCallUIKit

# 将源码复制进去
cp -r <your-rn-sources>/* raw-materials/sources/rn/
```

### Step 3: 生成索引

```bash
npm run generate-docs-index
npm run generate-source-index
npm run generate-shards.ts  # 可选
```

### Step 4: 配置平台入口

编辑 `data/platforms/index.json`:

```json
{
  "modules": {
    "ChatUIKit": {
      "aliases": ["chat", "uikit"],
      "platforms": {
        "rn": {
          "status": "available",
          "entryRoutes": [
            {
              "surface": "component_props",
              "summary": "Component construction parameters",
              "docPath": "rn/guides/chatuikit/Components.md",
              "examples": ["ChatMessageList", "ChatView"]
            }
          ]
        }
      }
    }
  }
}
```

### Step 5: 测试

```bash
# 运行搜索测试
npm test

# 或手动测试
curl http://localhost:3000/tools/search_api -X POST -d '{"query":"send message","platform":"rn"}'
```

---

## 参考

- [PLATFORM_ENTRY_ROUTING.md](./PLATFORM_ENTRY_ROUTING.md) - 平台入口路由详解
- [TECHNICAL_OVERVIEW.md](./TECHNICAL_OVERVIEW.md) - 技术总体设计
- `scripts/generate-docs-index.ts` - 文档索引生成源码
- `scripts/generate-source-index.ts` - 源码索引生成源码
