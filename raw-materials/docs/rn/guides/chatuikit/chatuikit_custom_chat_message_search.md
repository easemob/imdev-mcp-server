# 消息搜索组件

本文介绍如何通过 `MessageSearch` 组件实现聊天消息的搜索功能，包括搜索框、搜索结果列表展示等。

## 概述

`MessageSearch` 组件是一个用于在特定会话中搜索消息的组件。该组件提供了搜索框和搜索结果列表，支持按关键词搜索会话中的历史消息。

`MessageSearch` 组件支持以下自定义设置：

- [消息搜索组件](#消息搜索组件)
  - [概述](#概述)
  - [基本使用](#基本使用)
  - [设置容器样式](#设置容器样式)
  - [处理搜索结果点击](#处理搜索结果点击)
  - [处理取消操作](#处理取消操作)
  - [相关文档](#相关文档)

## 基本使用

使用示例如下：

```typescript
import { MessageSearch } from 'react-native-chat-uikit';
import type { ChatConversationType } from 'react-native-chat-sdk';

function MessageSearchScreen({ route, navigation }) {
  const { convId, convType } = route.params;

  return (
    <MessageSearch
      convId={convId}
      convType={convType}
      onClickedItem={(model) => {
        console.log('点击消息:', model.msg.msgId);
        // 跳转到聊天页面并定位到该消息
        navigation.navigate('Chat', {
          convId: convId,
          convType: convType,
          msgId: model.msg.msgId,
        });
      }}
      onCancel={() => {
        navigation.goBack();
      }}
    />
  );
}
```

`MessageSearch` 组件属性如下表所示：

| 属性              | 类型                                    | 是否必需 | 描述                                                                                            |
| ----------------- | --------------------------------------- | -------- | ----------------------------------------------------------------------------------------------- |
| `convId`          | `string`                                | 是       | 会话 ID。                                                                                       |
| `convType`        | `ChatConversationType`                  | 是       | 会话类型。<br/> - `PeerChat`（0）：单聊。<br/> - `GroupChat`（1）：群聊。                       |
| `containerStyle`  | `StyleProp<ViewStyle>`                  | 否       | 容器的样式。详见[设置容器样式](#设置容器样式)。                                                 |
| `onClickedItem`   | `(model: MessageSearchModel) => void`   | 否       | 点击搜索结果条目的回调。详见[处理搜索结果点击](#处理搜索结果点击)。                             |
| `onCancel`        | `(data?: MessageSearchModel) => void`   | 否       | 点击取消按钮的回调。详见[处理取消操作](#处理取消操作)。                                         |
| `testMode`        | `'only-ui' \| 'with-ui' \| 'only-test'` | 否       | 测试模式。一般用户无需关注此属性。<br/> - `only-ui`：仅 UI 模式。<br/> - `with-ui`：带 UI 测试。 |

:::tip
React Native 的 UIKit 没有内置路由跳转功能，搜索结果的点击和取消操作需要通过回调函数自行处理页面跳转。
:::

## 设置容器样式

通过 `containerStyle` 属性可以自定义搜索组件容器的样式：

```typescript
<MessageSearch
  convId={convId}
  convType={convType}
  containerStyle={{
    backgroundColor: '#f5f5f5',
    paddingTop: 10,
  }}
  onCancel={() => navigation.goBack()}
/>
```

## 处理搜索结果点击

通过 `onClickedItem` 回调处理搜索结果条目的点击事件。通常用于跳转到聊天页面并定位到该消息：

```typescript
<MessageSearch
  convId={convId}
  convType={convType}
  onClickedItem={(model) => {
    console.log('消息 ID:', model.msg.msgId);
    console.log('消息内容:', model.msg.body);
    console.log('发送者:', model.userId);
    console.log('用户名:', model.userName);

    // 跳转到聊天页面并定位到该消息
    navigation.navigate('Chat', {
      convId: convId,
      convType: convType,
      msgId: model.msg.msgId, // 传递消息 ID 以便定位
    });
  }}
  onCancel={() => navigation.goBack()}
/>
```

**MessageSearchModel** 数据模型包含以下主要字段：

- `msg: ChatMessage`: 消息对象，包含消息的完整信息
- `userId: string`: 发送者的用户 ID
- `userName?: string`: 发送者的用户名
- `userAvatar?: string`: 发送者的头像 URL

## 处理取消操作

通过 `onCancel` 回调处理取消按钮的点击事件。通常用于返回上一页：

```typescript
<MessageSearch
  convId={convId}
  convType={convType}
  onClickedItem={(model) => {
    navigation.navigate('Chat', {
      convId: convId,
      convType: convType,
      msgId: model.msg.msgId,
    });
  }}
  onCancel={(data) => {
    console.log('取消搜索');
    navigation.goBack();
  }}
/>
```

## 相关文档

- [聊天页面介绍](chatuikit_custom_chat_intro.html)
- [聊天页面基本设置](chatuikit_custom_chat_basic.html)
- [消息列表组件](chatuikit_custom_chat_message_list.html)
