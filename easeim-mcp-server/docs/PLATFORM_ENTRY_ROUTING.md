# 平台能力矩阵与入口路由接入指南

## 背景

为避免跨平台配置入口不一致导致的误答，系统引入“平台能力矩阵 + 入口路由”机制：

- 先判断 **模块（ChatUIKit / CallKit） + 平台（iOS/Android/Web/RN/Flutter/Harmony）**
- 再根据平台入口类型分流：
  - `appearance`（全局外观）
  - `options`（初始化开关）
  - `component_props`（组件构造参数）
  - `theme_tokens`（主题变量）
  - `override`（源码扩展）

当前状态：

- 入口路由（`entryRoutes`）目前以 iOS 为主，其余平台可继续按模板补充。
- 运行时能力约束已覆盖全平台（`android/ios/web/rn/flutter/harmony`），在“平台有内容”和“平台无内容”两种场景下都能稳定分流。

## 入口路由配置文件

位置：`data/platforms/index.json`

结构说明：

- `modules.<moduleId>.aliases`：用于从用户问题中识别模块
- `modules.<moduleId>.platforms.<platform>`：平台入口路由信息
- `entryRoutes`：入口列表（可多条）
- `status`：`available` / `planned`

## 接入新平台的步骤

1. **准备文档与源码**
   - 将文档和源码放入 `raw-materials/` 后生成：
     - `npm run generate-docs-index`
     - `npm run generate-source-index`
     - `npm run generate-config-index`

2. **补充入口路由**
   - 编辑 `data/platforms/index.json`
   - 给对应模块和平台添加 `entryRoutes`

3. **补充识别入口（可选）**
   - 若平台命名/关键词新增，更新：
     - `src/utils/ResponseBuilder.ts` 中 `detectMissingPlatform`
     - `data/intents/index.json` 中的 `patterns` / `aliases`

4. **补充场景索引（可选）**
   - 如需语义更稳定，补充：
     - `data/knowledge/index.json`
     - `data/knowledge/shards/<platform>.json`
     - `data/knowledge/manifest.json`

## 平台入口模板（示例）

### Web / RN / Flutter（组件构造参数为主）

```json
{
  "surface": "component_props",
  "summary": "组件构造参数配置入口",
  "docPath": "web/guides/chatuikit/Components.md",
  "examples": [
    "ChatMessageList.messageLongPressMenu",
    "ChatView.messageLongPressMenuBuilder"
  ]
}
```

### Android（主题/样式/Options）

```json
{
  "surface": "theme_tokens",
  "summary": "主题与样式入口",
  "docPath": "android/guides/chatuikit/Theme.md",
  "examples": [
    "R.style.ease_chat_message_text",
    "EaseChatUIKitTheme"
  ]
}
```

## 注意事项

- 保持 `entryRoutes` 的 **平台语义一致**，不要强行统一配置名。
- iOS 仍以 `Appearance` 为首要入口，找不到再走 `ChatUIKitOptions/UIOptions`。
- 如果平台未接入，系统会提示“入口未接入”并引导回到本指南。

## 2026-03 运行时能力约束补充

为避免用户在无覆盖能力上反复追问，`smart_assist` 增加了“平台能力约束”分支：

- 当平台确实无能力内容时，直接返回“当前无对应内容”，并附上覆盖证据（docs/sources 命中情况）。
- 当平台能力存在但命名有差异时，返回归一说明并给出正确组件路径。

当前内置规则（与 raw-materials 实际覆盖保持一致）：

- `flutter`：聊天室能力并入 `EaseChatUIKit`，无单独 `EaseChatroomUIKit`。
- `flutter`：无 `CallKit` 覆盖。
- `harmony`：无 `CallKit` 覆盖。
- `harmony`：`ChatroomUIKit` 无独立 demo 源码，仅保留 SDK 文档 + ChatUIKit 源码/文档覆盖。
