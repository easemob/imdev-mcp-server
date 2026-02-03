# 消息输入组件的设置

本文介绍如何通过 `MessageInput` 组件实现消息输入的自定义设置，包括发送文本、表情、文件、图片、语音等功能。

## 概述

`MessageInput` 组件用于发送文本、表情、文件、图片、语音等消息。可以自定义发送菜单，添加自定义消息类型的发送 UI。通常与 `MessageList` 组件配合使用。

`MessageInput` 组件支持以下自定义设置：

- [消息输入组件的设置](#消息输入组件的设置)
  - [概述](#概述)
  - [基本使用](#基本使用)
  - [设置输入行数](#设置输入行数)
  - [自定义表情列表](#自定义表情列表)
  - [自定义扩展菜单](#自定义扩展菜单)
    - [添加、删除、修改菜单项](#添加删除修改菜单项)
    - [修改菜单图标](#修改菜单图标)
    - [选择菜单样式](#选择菜单样式)
      - [1. 底部弹出菜单样式 (bottom-sheet)](#1-底部弹出菜单样式-bottom-sheet)
      - [2. 扩展面板样式 (extension)](#2-扩展面板样式-extension)
  - [监听输入变化](#监听输入变化)
  - [处理发送事件](#处理发送事件)
  - [使用控制器](#使用控制器)
    - [关闭输入框](#关闭输入框)
    - [引用消息](#引用消息)
    - [编辑消息](#编辑消息)
    - [显示/隐藏多选模式](#显示隐藏多选模式)
    - [显示/隐藏遮罩层](#显示隐藏遮罩层)
  - [MessageInputRef 控制器方法](#messageinputref-控制器方法)
  - [扩展菜单图标说明](#扩展菜单图标说明)
  - [相关文档](#相关文档)

## 基本使用

`MessageInput` 组件通常不会单独使用，而是作为 `ConversationDetail` 组件的一部分。如果需要单独使用或自定义，可以通过 `ConversationDetail` 的 `input` 属性进行配置：

```typescript
import { ConversationDetail, MessageInput } from 'react-native-chat-uikit';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      input={{
        props: {
          // 传递给 MessageInput 的属性
          numberOfLines: 4,
          closeAfterSend: true,
          onChangeValue: (text) => {
            console.log('输入内容变化:', text);
          },
          onClickedSend: (value) => {
            console.log('发送消息:', value);
          },
        },
        // render: MessageInput, // 可选：使用自定义的 MessageInput 组件
        ref: messageInputRef, // 获取 MessageInput 的控制器
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

`MessageInput` 组件基本属性如下表所示：

| 属性                               | 类型                                 | 是否必需 | 描述                                                                                                                                                      |
| ---------------------------------- | ------------------------------------ | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `type`                             | `ConversationDetailModelType`        | 是       | 消息输入组件的类型。<br/> - `chat`：普通聊天页面。<br/> - `create_thread`：创建话题页面。<br/> - `thread`：话题聊天页面。<br/> - `search`：搜索消息页面。 |
| `convId`                           | `string`                             | 是       | 会话 ID。                                                                                                                                                 |
| `convType`                         | `ChatConversationType`               | 是       | 会话类型。                                                                                                                                                |
| `numberOfLines`                    | `number`                             | 否       | 输入框的最大行数。默认为 4 行。详见[设置输入行数](#设置输入行数)。                                                                                        |
| `top`                              | `number`                             | 否       | 键盘避让的顶部偏移量。                                                                                                                                    |
| `bottom`                           | `number`                             | 否       | 键盘避让的底部偏移量。                                                                                                                                    |
| `onClickedSend`                    | `(value) => void`                    | 否       | 点击发送按钮的回调。参数为发送的消息内容（文本、文件、图片、视频、语音或名片）。详见[处理发送事件](#处理发送事件)。                                       |
| `closeAfterSend`                   | `boolean`                            | 否       | 发送消息后是否关闭扩展菜单和表情面板。默认为 `false`。                                                                                                    |
| `onHeightChange`                   | `(height: number) => void`           | 否       | 输入组件高度变化时的回调。                                                                                                                                |
| `onEditMessageFinished`            | `(model: MessageModel) => void`      | 否       | 编辑消息完成时的回调。                                                                                                                                    |
| `onInputMention`                   | `(groupId: string) => void`          | 否       | 点击 @ 提及功能时的回调（群聊中）。                                                                                                                       |
| `onClickedCardMenu`                | `() => void`                         | 否       | 点击名片菜单时的回调。                                                                                                                                    |
| `onInitMenu`                       | `(initItems) => InitMenuItemsType[]` | 否       | 初始化扩展菜单时的回调，可以添加、修改或删除菜单项。详见[自定义扩展菜单](#自定义扩展菜单)。                                                               |
| `emojiList`                        | `string[]`                           | 否       | 自定义表情列表。详见[自定义表情列表](#自定义表情列表)。                                                                                                   |
| `onChangeValue`                    | `(text: string) => void`             | 否       | 输入内容变化时的回调。详见[监听输入变化](#监听输入变化)。                                                                                                 |
| `selectType`                       | `ConversationSelectModeType`         | 否       | 消息选择模式。<br/> - `common`（默认）：普通模式。<br/> - `multi`：多选模式。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。           |
| `multiSelectCount`                 | `number`                             | 否       | 多选模式下已选消息的数量。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。                                                              |
| `onClickedMultiSelectDeleteButton` | `() => void`                         | 否       | 多选模式下点击删除按钮的回调。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。                                                          |
| `onClickedMultiSelectShareButton`  | `() => void`                         | 否       | 多选模式下点击分享按钮的回调。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。                                                          |
| `unreadCount`                      | `number`                             | 否       | 未读消息数量。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。                                                                          |
| `onClickedUnreadCount`             | `() => void`                         | 否       | 点击未读消息数量按钮的回调。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。                                                            |

:::note
**注意**: 表格中标注"主要用于内部组件之间通信"的属性通常由 `ConversationDetail` 组件自动处理，一般用户无需关注。
:::

## 设置输入行数

通过 `numberOfLines` 属性可以设置输入框的最大行数：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      numberOfLines: 6, // 最多显示 6 行
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

默认情况下，`numberOfLines` 为 4 行。超过最大行数后，输入框会出现滚动条。

## 自定义表情列表

通过 `emojiList` 属性可以自定义表情列表：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      emojiList: [
        '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂',
        '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩',
        '😘', '😗', '😚', '😙', '😋', '😛', '😜', '🤪',
        // ... 更多表情
      ],
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

如果不设置 `emojiList`，组件会使用默认的表情列表。

## 自定义扩展菜单

扩展菜单提供了灵活的自定义能力，你可以添加、删除、修改菜单项，自定义菜单图标，以及选择菜单的显示样式。

### 添加、删除、修改菜单项

通过 `onInitMenu` 回调可以自定义扩展菜单项：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      onInitMenu: (initItems) => {
        // initItems 是默认的菜单项列表
        console.log('默认菜单项:', initItems);

        // 1. 添加自定义菜单项
        const customItem = {
          name: 'custom',      // 菜单项名称
          isHigh: false,       // 是否高亮显示（通常用于警告操作）
          icon: 'star_fill',   // 菜单项图标
          onClicked: () => {
            console.log('点击自定义菜单项');
            // 实现自定义功能
          },
        };

        // 2. 修改现有菜单项
        const modifiedItems = initItems.map((item) => {
          if (item.name === 'Photo') {
            // 修改图片菜单项的图标
            return { ...item, icon: 'img' };
          }
          return item;
        });

        // 3. 删除特定菜单项
        const filteredItems = modifiedItems.filter(
          (item) => item.name !== 'File' // 删除文件选择菜单
        );

        // 返回新的菜单项列表
        return [...filteredItems, customItem];
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

**InitMenuItemsType 类型定义：**

```typescript
type InitMenuItemsType = {
  name: string; // 菜单项显示的文本
  isHigh: boolean; // 是否高亮显示（true 为警告样式）
  icon?: IconNameType; // 菜单项图标名称
  onClicked?: (name: string, others?: any) => void; // 点击回调
};
```

### 修改菜单图标

默认的扩展菜单的图标在文档的尾部表格中。

菜单项的图标的修改方法请参考[图标自定义文档](./chatuikit_custom_icon.md)。

### 选择菜单样式

UIKit 提供了两种扩展菜单样式，可以在初始化时通过 `UIKitContainer` 的 `messageInputBarStyle` 属性设置：

#### 1. 底部弹出菜单样式 (bottom-sheet)

默认样式，菜单从屏幕底部弹出，提供更大的显示空间。

```typescript
import { UIKitContainer } from 'react-native-chat-uikit';

<UIKitContainer
  options={chatOptions}
  messageInputBarStyle="bottom-sheet"  // 底部弹出菜单（默认）
>
  {/* 你的应用内容 */}
</UIKitContainer>
```

#### 2. 扩展面板样式 (extension)

菜单在输入框上方展开显示，类似于表情面板的展示方式。

```typescript
import { UIKitContainer } from 'react-native-chat-uikit';

<UIKitContainer
  options={chatOptions}
  messageInputBarStyle="extension"  // 扩展面板样式
>
  {/* 你的应用内容 */}
</UIKitContainer>
```

**两种样式的对比：**

| 特性     | bottom-sheet（底部弹出） | extension（扩展面板）  |
| -------- | ------------------------ | ---------------------- |
| 显示位置 | 屏幕底部弹出             | 输入框上方展开         |
| 显示空间 | 较大                     | 中等                   |
| 用户体验 | 更像原生弹窗             | 与表情面板体验一致     |
| 适用场景 | 菜单项较多时             | 菜单项较少，追求简洁时 |
| 默认值   | 是                       | 否                     |

:::tip
`messageInputBarStyle` 是全局设置，会影响所有聊天页面的扩展菜单样式。如果你需要在不同页面使用不同的菜单样式，建议使用相同的样式以保持用户体验的一致性。
:::

## 监听输入变化

通过 `onChangeValue` 回调可以监听输入内容的变化：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      onChangeValue: (text) => {
        console.log('当前输入内容:', text);

        // 可以根据输入内容实现一些功能
        // 例如：显示正在输入状态、触发 @ 提及列表等
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

## 处理发送事件

通过 `onClickedSend` 回调可以拦截或扩展消息发送逻辑：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      onClickedSend: (value) => {
        console.log('发送消息类型:', value.type);

        // 根据消息类型进行不同处理
        switch (value.type) {
          case 'text':
            const textValue = value as SendTextProps;
            console.log('文本内容:', textValue.content);
            break;
          case 'image':
            const imageValue = value as SendImageProps;
            console.log('图片路径:', imageValue.localPath);
            console.log('图片尺寸:', imageValue.imageWidth, imageValue.imageHeight);
            break;
          case 'video':
            const videoValue = value as SendVideoProps;
            console.log('视频路径:', videoValue.localPath);
            console.log('缩略图路径:', videoValue.thumbLocalPath);
            break;
          case 'voice':
            const voiceValue = value as SendVoiceProps;
            console.log('语音路径:', voiceValue.localPath);
            console.log('语音时长:', voiceValue.duration);
            break;
          case 'file':
            const fileValue = value as SendFileProps;
            console.log('文件路径:', fileValue.localPath);
            console.log('文件名:', fileValue.displayName);
            break;
          case 'card':
            const cardValue = value as SendCardProps;
            console.log('名片用户ID:', cardValue.userId);
            break;
        }

        // 如果需要自定义发送逻辑，可以在这里实现
        // 默认情况下，组件会自动处理消息发送
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

## 使用控制器

通过获取 `MessageInputRef` 引用，可以使用控制器方法实现更多高级功能。

### 关闭输入框

通过控制器的 `close` 方法可以关闭输入框（收起键盘、表情面板和扩展菜单）：

```typescript
import React, { useRef } from 'react';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  const handleCloseInput = () => {
    messageInputRef.current?.close();
  };

  return (
    <>
      <ConversationDetail
        type="chat"
        convId={convId}
        convType={convType}
        input={{
          ref: messageInputRef,
        }}
        onBack={() => navigation.goBack()}
      />
      <Button title="关闭输入框" onPress={handleCloseInput} />
    </>
  );
}
```

### 引用消息

通过控制器的 `quoteMessage` 方法可以引用（回复）消息：

```typescript
import React, { useRef } from 'react';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  const handleQuoteMessage = (messageModel: MessageModel) => {
    messageInputRef.current?.quoteMessage(messageModel);
  };

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      input={{
        ref: messageInputRef,
      }}
      list={{
        props: {
          onClickedItem: (id, model) => {
            if (model.modelType === 'message') {
              // 点击消息时引用该消息
              handleQuoteMessage(model as MessageModel);
              return false; // 阻止默认行为
            }
          },
        },
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

调用 `quoteMessage` 后，输入框上方会显示被引用的消息内容，用户发送的消息会包含引用信息。

### 编辑消息

通过控制器的 `editMessage` 方法可以编辑消息：

```typescript
import React, { useRef } from 'react';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  const handleEditMessage = (messageModel: MessageModel) => {
    messageInputRef.current?.editMessage(messageModel);
  };

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      input={{
        ref: messageInputRef,
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

调用 `editMessage` 后，会弹出编辑消息的 UI，用户可以修改消息内容并重新发送。

### 显示/隐藏多选模式

通过控制器的 `showMultiSelect` 和 `hideMultiSelect` 方法可以控制多选模式：

```typescript
import React, { useRef } from 'react';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  const handleShowMultiSelect = () => {
    messageInputRef.current?.showMultiSelect();
  };

  const handleHideMultiSelect = () => {
    messageInputRef.current?.hideMultiSelect();
  };

  return (
    <>
      <ConversationDetail
        type="chat"
        convId={convId}
        convType={convType}
        input={{
          ref: messageInputRef,
        }}
        onBack={() => navigation.goBack()}
      />
      <View style={{ flexDirection: 'row' }}>
        <Button title="显示多选" onPress={handleShowMultiSelect} />
        <Button title="隐藏多选" onPress={handleHideMultiSelect} />
      </View>
    </>
  );
}
```

多选模式下，输入组件会显示删除和分享按钮，而不是正常的输入框。

### 显示/隐藏遮罩层

通过控制器的 `showMask` 和 `hideMask` 方法可以控制遮罩层的显示：

```typescript
import React, { useRef } from 'react';
import type { MessageInputRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageInputRef = useRef<MessageInputRef>(null);

  const handleShowMask = () => {
    messageInputRef.current?.showMask();
  };

  const handleHideMask = () => {
    messageInputRef.current?.hideMask();
  };

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      input={{
        ref: messageInputRef,
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

遮罩层通常用于群聊中的置顶消息显示时，防止用户操作输入框。

## MessageInputRef 控制器方法

`MessageInputRef` 提供以下控制器方法：

| 方法名            | 参数                  | 返回值 | 描述                                                     |
| ----------------- | --------------------- | ------ | -------------------------------------------------------- |
| `close`           | 无                    | `void` | 关闭输入框（收起键盘、表情面板和扩展菜单）。             |
| `quoteMessage`    | `model: MessageModel` | `void` | 引用（回复）指定消息。输入框上方会显示被引用的消息内容。 |
| `editMessage`     | `model: MessageModel` | `void` | 编辑指定消息。会弹出编辑 UI 供用户修改消息内容。         |
| `showMultiSelect` | 无                    | `void` | 显示多选模式。输入组件会显示删除和分享按钮。             |
| `hideMultiSelect` | 无                    | `void` | 隐藏多选模式。恢复正常的输入框。                         |
| `showMask`        | 无                    | `void` | 显示遮罩层。通常用于置顶消息显示时，防止用户操作输入框。 |
| `hideMask`        | 无                    | `void` | 隐藏遮罩层。恢复输入框的正常交互。                       |

## 扩展菜单图标说明

_菜单图标修改参考图标自定义文档。_

输入框的扩展菜单使用以下默认图标：

| 功能     | 图标名称                | 描述                   |
| -------- | ----------------------- | ---------------------- |
| 选择图片 | `img`                   | 从相册选择图片         |
| 选择视频 | `triangle_in_rectangle` | 从相册选择视频         |
| 拍照     | `camera_fill`           | 打开相机拍照           |
| 选择文件 | `folder`                | 选择文件发送           |
| 选择名片 | `person_single_fill`    | 选择联系人名片发送     |
| 自定义   | `star_fill`             | 默认的自定义菜单项图标 |

输入框的其他图标：

| 功能         | 图标名称           | 描述                     |
| ------------ | ------------------ | ------------------------ |
| 发送语音     | `wave_in_circle`   | 切换到语音输入模式       |
| 表情         | `face`             | 打开表情选择面板         |
| 键盘         | `keyboard2`        | 关闭表情面板，显示键盘   |
| 打开扩展菜单 | `plus_in_circle`   | 打开扩展菜单             |
| 关闭扩展菜单 | `xmark_in_circle`  | 关闭扩展菜单             |
| 发送消息     | `airplane`         | 发送消息                 |
| 删除（多选） | `trash`            | 多选模式下的删除按钮     |
| 分享（多选） | `arrowshape_right` | 多选模式下的分享转发按钮 |

## 相关文档

- [聊天页面介绍](chatuikit_custom_chat_intro.html)
- [聊天页面的基本设置](chatuikit_custom_chat_basic.html)
- [设置消息列表组件](chatuikit_custom_chat_message_list.html)
