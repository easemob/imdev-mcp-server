# 文案自定义

UIKit 提供了灵活的文案自定义机制，允许你修改界面上显示的所有文本内容。你可以替换单个文案，也可以添加完整的自定义语言版本。

## 概述

UIKit 的所有 UI 文本都存储在 **字符串集（StringSet）** 中，通过键值对的方式管理。UIKit 内置了中文（`zh-Hans`）和英文（`en`）两种语言，你可以：

1. **修改现有语言的部分文案** - 替换特定的文本内容
2. **覆盖现有语言的所有文案** - 提供完整的语言包
3. **添加新的语言支持** - 为 UIKit 添加其他语言版本（如日语、韩语等）

## 相关属性

在 `UIKitContainer` 组件中，有以下与文案相关的属性：

| 属性                | 类型           | 说明                                                                                                |
| ------------------- | -------------- | --------------------------------------------------------------------------------------------------- |
| `language`          | `LanguageCode` | 设置 UI 显示语言，默认为系统语言。支持：`en`, `zh-Hans`, `zh-Hant`, `ru`, `de`, `fr`, `ja`, `ko` 等 |
| `translateLanguage` | `LanguageCode` | 设置翻译功能的目标语言，默认为系统语言                                                              |
| `onInitLanguageSet` | `Function`     | 语言包初始化回调，用于自定义或扩展语言包                                                            |

### onInitLanguageSet 回调

```typescript
onInitLanguageSet?: () => (
  language: LanguageCode,
  defaultSet: StringSet
) => CreateStringSet | StringSet;
```

该回调会在语言初始化时调用，返回一个函数，该函数接收：

- `language`: 当前的语言代码
- `defaultSet`: UIKit 提供的默认语言包

返回自定义的 `StringSet` 对象。

## 字符串集结构

字符串集是一个键值对对象，值可以是字符串或函数：

```typescript
export interface StringSet {
  [key: string]: string | ((...args: any[]) => string);
}
```

示例：

```typescript
{
  '_uikit_search': '搜索',
  '_uikit_create_group_button': (count) => `创建(${count})`,
  '_uikit_msg_tip_recall': (isSelf: boolean, name) =>
    isSelf === true ? `你撤回了一条消息` : `${name}撤回了一条消息`,
}
```

## 使用场景

### 场景 1：修改部分文案

如果只想修改某些特定的文本，可以通过 `onInitLanguageSet` 覆盖默认值：

```tsx
import {
  UIKitContainer,
  createStringSetCn,
  createStringSetEn,
} from "react-native-chat-uikit";

function App() {
  const onInitLanguageSet = React.useCallback(() => {
    return (language, defaultSet) => {
      // 在默认语言包基础上修改
      if (language === "zh-Hans") {
        return {
          ...createStringSetCn(),
          // 修改特定文案
          _uikit_search: "查找",
          _uikit_contact_title: "通讯录",
          _uikit_create_group_button: (count) => `确认创建(${count}人)`,
        };
      } else if (language === "en") {
        return {
          ...createStringSetEn(),
          // 修改特定文案
          _uikit_search: "Find",
          _uikit_contact_title: "Address Book",
        };
      }
      return defaultSet;
    };
  }, []);

  return (
    <UIKitContainer
      options={chatOptions}
      language="zh-Hans"
      onInitLanguageSet={onInitLanguageSet}
    >
      {/* Your app content */}
    </UIKitContainer>
  );
}
```

### 场景 2：添加完整的自定义语言

为 UIKit 添加新的语言支持（例如日语）：

**步骤 1：创建语言包文件**

```typescript
// StringSet.ja.tsx
import type { StringSet } from "react-native-chat-uikit";

export function createStringSetJa(): StringSet {
  return {
    // 基础功能
    _uikit_search: "検索",
    _uikit_search_placeholder: "キーワードを検索",
    _uikit_contact_title: "連絡先",
    _uikit_new_conv_title: "新しい会話",
    _uikit_create_group_title: "グループを作成",
    _uikit_create_group_button: (count) => `作成(${count})`,

    // 联系人相关
    _uikit_contact_new_request: "新しいリクエスト",
    _uikit_contact_group_list: "グループ",
    _uikit_contact_black_list: "ブロックリスト",
    _uikit_contact_menu_add_contact: "連絡先を追加",

    // 消息相关
    _uikit_msg_tip_recall: (isSelf: boolean, name) =>
      isSelf
        ? "メッセージを取り消しました"
        : `${name}がメッセージを取り消しました`,
    _uikit_msg_tip_not_support: "サポートされていないメッセージタイプ",

    // 聊天输入
    _uikit_chat_input_long_press_menu_picture: "ギャラリー",
    _uikit_chat_input_long_press_menu_video: "ビデオ",
    _uikit_chat_input_long_press_menu_camera: "カメラ",
    _uikit_chat_input_long_press_menu_file: "ファイル",
    _uikit_chat_input_long_press_menu_card: "名刺",

    // 长按菜单
    _uikit_chat_list_long_press_menu_copy: "コピー",
    _uikit_chat_list_long_press_menu_replay: "返信",
    _uikit_chat_list_long_press_menu_delete: "削除",
    _uikit_chat_list_long_press_menu_recall: "取り消し",

    // 通用文案
    search: "検索",
    cancel: "キャンセル",
    confirm: "確認",
    save: "保存",
    add: "追加",
    remove: "削除",

    // ... 添加所有需要的文案
  };
}
```

**步骤 2：在应用中使用**

```tsx
import {
  UIKitContainer,
  createStringSetCn,
  createStringSetEn,
} from "react-native-chat-uikit";
import { createStringSetJa } from "./i18n/StringSet.ja";

function App() {
  const onInitLanguageSet = React.useCallback(() => {
    return (language, defaultSet) => {
      switch (language) {
        case "zh-Hans":
          return createStringSetCn();
        case "en":
          return createStringSetEn();
        case "ja":
          return createStringSetJa();
        default:
          return defaultSet;
      }
    };
  }, []);

  return (
    <UIKitContainer
      options={chatOptions}
      language="ja" // 使用日语
      onInitLanguageSet={onInitLanguageSet}
    >
      {/* Your app content */}
    </UIKitContainer>
  );
}
```

### 场景 3：动态切换语言

```tsx
import { UIKitContainer } from "react-native-chat-uikit";

function App() {
  const [currentLanguage, setCurrentLanguage] =
    React.useState<LanguageCode>("zh-Hans");

  const onInitLanguageSet = React.useCallback(() => {
    return (language, defaultSet) => {
      if (language === "zh-Hans") {
        return {
          ...createStringSetCn(),
          // 可以添加自定义修改
        };
      } else if (language === "en") {
        return {
          ...createStringSetEn(),
          // 可以添加自定义修改
        };
      }
      return defaultSet;
    };
  }, []);

  // 切换语言
  const switchLanguage = (lang: LanguageCode) => {
    setCurrentLanguage(lang);
  };

  return (
    <UIKitContainer
      options={chatOptions}
      language={currentLanguage}
      onInitLanguageSet={onInitLanguageSet}
    >
      {/* Your app content */}
      <Button title="切换到英文" onPress={() => switchLanguage("en")} />
      <Button title="切换到中文" onPress={() => switchLanguage("zh-Hans")} />
    </UIKitContainer>
  );
}
```

## 常用文案键值对照表

### 基础功能

| 键名                        | 中文     | 英文         | 说明         |
| --------------------------- | -------- | ------------ | ------------ |
| `_uikit_search`             | 搜索     | Search       | 搜索按钮     |
| `_uikit_contact_title`      | 联系人   | Contacts     | 联系人标题   |
| `_uikit_new_conv_title`     | 新会话   | New Chat     | 新会话标题   |
| `_uikit_create_group_title` | 创建群组 | Create Group | 创建群组标题 |

### 联系人相关

| 键名                              | 中文       | 英文         | 说明           |
| --------------------------------- | ---------- | ------------ | -------------- |
| `_uikit_contact_new_request`      | 新请求     | New Requests | 新的好友请求   |
| `_uikit_contact_group_list`       | 群组       | Groups       | 群组列表       |
| `_uikit_contact_black_list`       | 黑名单     | Blocklist    | 黑名单         |
| `_uikit_contact_menu_add_contact` | 添加联系人 | Add Contact  | 添加联系人菜单 |

### 消息相关

| 键名                         | 类型                                        | 说明             |
| ---------------------------- | ------------------------------------------- | ---------------- |
| `_uikit_msg_tip_recall`      | `(isSelf: boolean, name: string) => string` | 撤回消息提示     |
| `_uikit_msg_tip_not_support` | `string`                                    | 不支持的消息类型 |
| `_uikit_msg_edit`            | `string`                                    | 已编辑标记       |
| `_uikit_msg_translate`       | `string`                                    | 已翻译标记       |

### 聊天输入

| 键名                                        | 中文 | 英文    | 说明     |
| ------------------------------------------- | ---- | ------- | -------- |
| `_uikit_chat_input_long_press_menu_picture` | 相册 | Gallery | 选择图片 |
| `_uikit_chat_input_long_press_menu_video`   | 视频 | Video   | 选择视频 |
| `_uikit_chat_input_long_press_menu_camera`  | 相机 | Camera  | 打开相机 |
| `_uikit_chat_input_long_press_menu_file`    | 文件 | File    | 选择文件 |
| `_uikit_chat_input_long_press_menu_card`    | 名片 | Card    | 分享名片 |

### 长按菜单

| 键名                                               | 中文 | 英文    | 说明     |
| -------------------------------------------------- | ---- | ------- | -------- |
| `_uikit_chat_list_long_press_menu_copy`            | 复制 | Copy    | 复制消息 |
| `_uikit_chat_list_long_press_menu_replay`          | 回复 | Reply   | 回复消息 |
| `_uikit_chat_list_long_press_menu_delete`          | 删除 | Delete  | 删除消息 |
| `_uikit_chat_list_long_press_menu_recall`          | 撤回 | Recall  | 撤回消息 |
| `_uikit_chat_list_long_press_menu_forward_message` | 转发 | Forward | 转发消息 |

### 通用文案

| 键名      | 中文 | 英文    | 说明 |
| --------- | ---- | ------- | ---- |
| `search`  | 搜索 | Search  | 搜索 |
| `cancel`  | 取消 | Cancel  | 取消 |
| `confirm` | 确认 | Confirm | 确认 |
| `save`    | 保存 | Save    | 保存 |
| `add`     | 添加 | Add     | 添加 |
| `remove`  | 删除 | Remove  | 删除 |

## 完整字符串集参考

要查看所有可用的文案键值，请参考 UIKit 源码中的字符串集文件：

- **中文字符串集**：`StringSet.cn.tsx` - 包含所有中文文案
- **英文字符串集**：`StringSet.en.tsx` - 包含所有英文文案

建议复制这些文件作为模板，创建自己的语言版本。

## 最佳实践

### 1. 保持键名一致

自定义语言包时，确保使用与内置语言包相同的键名，这样才能正确替换文案。

### 2. 处理动态文案

某些文案包含动态内容（如用户名、数量等），需要使用函数形式：

```typescript
{
  // ❌ 错误：使用字符串无法动态插入内容
  '_uikit_create_group_button': '创建(count)',

  // ✅ 正确：使用函数返回动态内容
  '_uikit_create_group_button': (count) => `创建(${count})`,
}
```

## 常见问题

### Q1: 如何查看所有可用的文案键名？

查看 UIKit 源码中的 `StringSet.cn.tsx` 或 `StringSet.en.tsx` 文件，包含了所有文案的键名和默认值。

### Q2: 修改文案后没有生效？

检查以下几点：

1. 确认 `onInitLanguageSet` 回调已正确设置
2. 确认返回的对象包含了修改的键值
3. 确认键名拼写正确（区分大小写）
4. 尝试重启应用
