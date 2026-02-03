# 消息列表组件的设置

本文介绍如何通过 `MessageList` 组件实现消息列表的自定义设置，包括消息显示、点击事件监听、历史消息加载等功能。

## 概述

`MessageList` 组件用于显示发送和接收的消息、播放语音消息、预览图片和视频、下载文件等。该组件可以自定义消息的点击行为、样式以及添加自定义消息类型。通常与 `MessageInput` 组件配合使用。

`MessageList` 组件支持以下自定义设置：

- [消息列表组件的设置](#消息列表组件的设置)
  - [概述](#概述)
  - [基本使用](#基本使用)
  - [设置容器样式](#设置容器样式)
  - [设置点击事件](#设置点击事件)
    - [点击消息条目](#点击消息条目)
    - [长按消息条目](#长按消息条目)
    - [点击消息头像](#点击消息头像)
    - [点击引用消息](#点击引用消息)
  - [自动滚动设置](#自动滚动设置)
  - [消息布局类型](#消息布局类型)
  - [自定义消息上报](#自定义消息上报)
  - [自定义消息上下文菜单](#自定义消息上下文菜单)
    - [InitMenuItemsType 结构](#initmenuitemstype-结构)
    - [添加自定义菜单项](#添加自定义菜单项)
    - [修改默认菜单项](#修改默认菜单项)
    - [删除默认菜单项](#删除默认菜单项)
    - [修改菜单图标](#修改菜单图标)
    - [选择菜单样式](#选择菜单样式)
      - [使用底部弹出菜单样式（默认）](#使用底部弹出菜单样式默认)
      - [使用上下文菜单样式](#使用上下文菜单样式)
      - [使用自定义菜单组件](#使用自定义菜单组件)
  - [自定义消息气泡样式](#自定义消息气泡样式)
    - [MessageListItemRenders 组成](#messagelistitemrenders-组成)
    - [自定义消息内容（MessageContent）](#自定义消息内容messagecontent)
      - [基本使用示例](#基本使用示例)
      - [自定义图片消息显示](#自定义图片消息显示)
    - [自定义消息视图（MessageView）](#自定义消息视图messageview)
      - [示例：隐藏左侧消息的头像](#示例隐藏左侧消息的头像)
    - [自定义消息气泡（MessageBubble）](#自定义消息气泡messagebubble)
    - [组合使用多个自定义组件](#组合使用多个自定义组件)
    - [实际项目示例](#实际项目示例)
    - [注意事项](#注意事项)
  - [使用控制器](#使用控制器)
    - [添加消息到列表](#添加消息到列表)
    - [移除消息](#移除消息)
    - [撤回消息](#撤回消息)
    - [更新消息](#更新消息)
    - [滚动到底部](#滚动到底部)
    - [多选消息操作](#多选消息操作)
    - [置顶消息操作](#置顶消息操作)
  - [MessageListRef 控制器方法](#messagelistref-控制器方法)
  - [图标说明](#图标说明)
    - [消息上下文菜单图标](#消息上下文菜单图标)
    - [消息状态图标](#消息状态图标)
  - [相关文档](#相关文档)

## 基本使用

`MessageList` 组件通常不会单独使用，而是作为 `ConversationDetail` 组件的一部分。如果需要单独使用或自定义，可以通过 `ConversationDetail` 的 `list` 属性进行配置：

```typescript
import { ConversationDetail, MessageList } from 'react-native-chat-uikit';
import type { MessageListRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageListRef = useRef<MessageListRef>(null);

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      list={{
        props: {
          // 传递给 MessageList 的属性
          onClickedItem: (id, model) => {
            console.log('点击消息:', id, model);
          },
          recvMessageAutoScroll: true,
          containerStyle: {
            backgroundColor: '#f5f5f5',
          },
        },
        // render: MessageList, // 可选：使用自定义的 MessageList 组件
        ref: messageListRef, // 获取 MessageList 的控制器
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

`MessageList` 组件基本属性如下表所示：

| 属性                            | 类型                                        | 是否必需 | 描述                                                                                                                                                                                     |
| ------------------------------- | ------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `type`                          | `ConversationDetailModelType`               | 是       | 消息列表的类型。<br/> - `chat`：普通聊天页面。<br/> - `create_thread`：创建话题页面。<br/> - `thread`：话题聊天页面。<br/> - `search`：搜索消息页面。                                    |
| `convId`                        | `string`                                    | 是       | 会话 ID。                                                                                                                                                                                |
| `convType`                      | `ChatConversationType`                      | 是       | 会话类型。                                                                                                                                                                               |
| `containerStyle`                | `StyleProp<ViewStyle>`                      | 否       | 消息列表容器的样式。详见[设置容器样式](#设置容器样式)。                                                                                                                                  |
| `onClickedItem`                 | `(id, model) => void \| boolean`            | 否       | 点击消息条目的回调。返回 `false` 可阻止默认行为。详见[点击消息条目](#点击消息条目)。                                                                                                     |
| `onLongPressItem`               | `(id, model) => void \| boolean`            | 否       | 长按消息条目的回调。返回 `false` 可阻止默认行为。详见[长按消息条目](#长按消息条目)。                                                                                                     |
| `onClickedItemAvatar`           | `(id, model) => void \| boolean`            | 否       | 点击消息头像的回调。返回 `false` 可阻止默认行为。详见[点击消息头像](#点击消息头像)。                                                                                                     |
| `onClickedItemQuote`            | `(id, model) => void \| boolean`            | 否       | 点击引用消息的回调。返回 `false` 可阻止默认行为。详见[点击引用消息](#点击引用消息)。                                                                                                     |
| `recvMessageAutoScroll`         | `boolean`                                   | 否       | 接收到新消息时是否自动滚动到最新消息。<br/> - `true`：自动滚动。<br/> - `false`（默认）：不自动滚动。<br/> 详见[自动滚动设置](#自动滚动设置)。                                           |
| `messageLayoutType`             | `MessageLayoutType`                         | 否       | 消息布局类型。<br/> - `left`：所有消息都在左侧。<br/> - `right`：所有消息都在右侧。<br/> - 不设置（默认）：发送的消息在右侧，接收的消息在左侧。<br/> 详见[消息布局类型](#消息布局类型)。 |
| `reportMessageCustomList`       | `{key: string, value: string}[]`            | 否       | 自定义消息上报内容列表。详见[自定义消息上报](#自定义消息上报)。                                                                                                                          |
| `listItemRenderProps`           | `MessageListItemRenders & {ListItemRender}` | 否       | 自定义消息列表项渲染组件。                                                                                                                                                               |
| `onInitMenu`                    | `(initItems) => InitMenuItemsType[]`        | 否       | 初始化消息长按菜单时的回调，可以添加、修改或删除菜单项。                                                                                                                                 |
| `onCopyFinished`                | `(content: string) => void`                 | 否       | 复制内容完成时的回调。                                                                                                                                                                   |
| `onNoMoreMessage`               | `() => void`                                | 否       | 没有更多历史消息时的回调。                                                                                                                                                               |
| `onCreateThread`                | `(params) => void`                          | 否       | 请求创建话题时的回调。                                                                                                                                                                   |
| `onOpenThread`                  | `(thread) => void`                          | 否       | 打开话题时的回调。                                                                                                                                                                       |
| `onCreateThreadResult`          | `(thread?, firstMessage?) => void`          | 否       | 创建话题结果的回调。                                                                                                                                                                     |
| `onClickedEditThreadName`       | `(thread) => void`                          | 否       | 点击编辑话题名称时的回调（话题模式下）。                                                                                                                                                 |
| `onClickedOpenThreadMemberList` | `(thread) => void`                          | 否       | 点击打开话题成员列表时的回调（话题模式下）。                                                                                                                                             |
| `onClickedLeaveThread`          | `(threadId) => void`                        | 否       | 点击离开话题时的回调（话题模式下）。                                                                                                                                                     |
| `onClickedDestroyThread`        | `(threadId) => void`                        | 否       | 点击销毁话题时的回调（话题模式下）。                                                                                                                                                     |
| `onClickedHistoryDetail`        | `(item) => void`                            | 否       | 点击历史消息详情时的回调。                                                                                                                                                               |
| `generateThreadName`            | `(msg: MessageModel) => string`             | 否       | 生成话题名称的回调函数。                                                                                                                                                                 |
| `MessageCustomLongPressMenu`    | `React.ForwardRefExoticComponent<...>`      | 否       | 自定义消息长按菜单组件。                                                                                                                                                                 |
| `thread`                        | `ChatMessageThread`                         | 否       | 话题对象（话题模式下需要）。                                                                                                                                                             |
| `msgId`                         | `string`                                    | 否       | 消息 ID（创建话题模式下需要）。                                                                                                                                                          |
| `parentId`                      | `string`                                    | 否       | 父级 ID（创建话题模式下需要）。                                                                                                                                                          |
| `newThreadName`                 | `string`                                    | 否       | 新话题名称（创建话题模式下需要）。                                                                                                                                                       |
| `firstMessage`                  | `SendMessageProps`                          | 否       | 第一条消息（话题模式下需要）。                                                                                                                                                           |

:::note
**注意**: 表格中未列出的一些属性（如 `onClicked`、`onQuoteMessageForInput`、`onEditMessageForInput`、`onClickedMultiSelected`、`onChangeMultiItems`、`onClickedSingleSelect`、`onChangeUnreadCount`、`onChangePinMaskHeight`、`onRequestClosePinMessage` 等）主要用于内部组件之间通信，一般用户无需关注。
:::

## 设置容器样式

通过 `containerStyle` 属性可以自定义消息列表容器的样式：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      containerStyle: {
        backgroundColor: '#f9f9f9',
        paddingHorizontal: 10,
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

## 设置点击事件

### 点击消息条目

通过 `onClickedItem` 处理消息条目的点击事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onClickedItem: (id, model) => {
        console.log('点击消息:', id);
        console.log('消息模型:', model);

        // 根据消息类型执行不同操作
        if (model.modelType === 'message') {
          const messageModel = model as MessageModel;
          if (messageModel.msg.body.type === ChatMessageType.IMAGE) {
            // 预览图片（默认行为已实现）
            console.log('预览图片');
          } else if (messageModel.msg.body.type === ChatMessageType.VIDEO) {
            // 播放视频（默认行为已实现）
            console.log('播放视频');
          }
        }

        // 返回 false 可阻止默认行为
        // return false;
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 长按消息条目

通过 `onLongPressItem` 处理消息条目的长按事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onLongPressItem: (id, model) => {
        console.log('长按消息:', id, model);

        // 默认会弹出消息上下文菜单
        // 返回 false 可阻止默认菜单弹出
        // return false;
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 点击消息头像

通过 `onClickedItemAvatar` 处理消息头像的点击事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onClickedItemAvatar: (id, model) => {
        console.log('点击头像:', id);

        if (model.modelType === 'message') {
          const messageModel = model as MessageModel;
          const senderId = messageModel.msg.from;

          // 跳转到用户详情页面
          navigation.navigate('UserDetail', { userId: senderId });

          // 返回 false 可阻止默认行为
          return false;
        }
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 点击引用消息

通过 `onClickedItemQuote` 处理引用消息的点击事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onClickedItemQuote: (id, model) => {
        console.log('点击引用消息:', id, model);

        // 默认会滚动到被引用的消息
        // 返回 false 可阻止默认行为
        // return false;
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

## 自动滚动设置

通过 `recvMessageAutoScroll` 属性可以控制接收到新消息时是否自动滚动到最新消息：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      recvMessageAutoScroll: true, // 接收到新消息时自动滚动
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

默认情况下，`recvMessageAutoScroll` 为 `false`，即不会自动滚动。这样可以避免在用户查看历史消息时突然跳转到最新消息。

## 消息布局类型

通过 `messageLayoutType` 属性可以控制消息的布局方式：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      // 所有消息都显示在左侧
      messageLayoutType: 'left',

      // 或者所有消息都显示在右侧
      // messageLayoutType: 'right',

      // 不设置则使用默认布局：发送的消息在右侧，接收的消息在左侧
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

这个功能可以用于特殊场景，例如客服消息或系统通知等。

## 自定义消息上报

通过 `reportMessageCustomList` 属性可以自定义消息上报的内容列表：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      reportMessageCustomList: [
        { key: 'spam', value: '垃圾消息' },
        { key: 'abuse', value: '辱骂信息' },
        { key: 'illegal', value: '违法内容' },
        { key: 'other', value: '其他' },
      ],
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

用户长按消息选择"举报"后，会显示自定义的上报内容列表供用户选择。

## 自定义消息上下文菜单

长按消息气泡会弹出消息上下文菜单，通过 `onInitMenu` 属性可以自定义菜单项，包括添加、修改和删除菜单项。

### InitMenuItemsType 结构

每个菜单项都是一个 `InitMenuItemsType` 对象，包含以下属性：

| 属性名      | 类型                           | 是否必需 | 描述                                   |
| ----------- | ------------------------------ | -------- | -------------------------------------- |
| `name`      | `string`                       | 是       | 菜单项显示的文本。                     |
| `isHigh`    | `boolean`                      | 是       | 是否高亮显示（通常用于危险操作）。     |
| `icon`      | `IconNameType`                 | 否       | 菜单项显示的图标名称。                 |
| `onClicked` | `(name, others?) => void`      | 否       | 点击菜单项时的回调函数。               |

### 添加自定义菜单项

可以在默认菜单项基础上添加自定义菜单项：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onInitMenu: (initItems) => {
        // 在默认菜单项后面添加自定义菜单项
        return [
          ...initItems,
          {
            name: '收藏',
            isHigh: false,
            icon: 'star',
            onClicked: (name) => {
              console.log('收藏消息:', name);
              // todo: 处理收藏逻辑
            },
          },
          {
            name: '翻译',
            isHigh: false,
            icon: 'globe',
            onClicked: () => {
              // todo: 处理翻译逻辑
            },
          },
        ];
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 修改默认菜单项

可以修改默认菜单项的属性：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onInitMenu: (initItems) => {
        // 修改"删除"菜单项的文本
        return initItems.map((item) => {
          if (item.name === '删除') {
            return {
              ...item,
              name: '彻底删除',
              isHigh: true, // 设置为高亮
            };
          }
          return item;
        });
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 删除默认菜单项

可以过滤掉不需要的默认菜单项：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      onInitMenu: (initItems) => {
        // 删除"转发"和"多选"菜单项
        return initItems.filter((item) => {
          return item.name !== '转发' && item.name !== '多选';
        });
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 修改菜单图标

默认的菜单的图标在文档的尾部表格中。

菜单项的图标的修改方法请参考[图标自定义文档](./chatuikit_custom_icon.md)。

### 选择菜单样式

消息上下文菜单支持两种样式风格，通过 `UIKitContainer` 的 `messageMenuStyle` 属性进行全局配置：

| 样式值         | 描述                                       |
| -------------- | ------------------------------------------ |
| `bottom-sheet` | 底部弹出菜单样式（默认），菜单从底部弹出。 |
| `context`      | 上下文菜单样式，菜单在长按位置附近弹出。   |
| `custom`       | 自定义菜单样式，需要提供自定义菜单组件。   |

#### 使用底部弹出菜单样式（默认）

```typescript
<UIKitContainer
  options={options}
  messageMenuStyle="bottom-sheet"
>
  {/* 应用内容 */}
</UIKitContainer>
```

#### 使用上下文菜单样式

```typescript
<UIKitContainer
  options={options}
  messageMenuStyle="context"
>
  {/* 应用内容 */}
</UIKitContainer>
```

#### 使用自定义菜单组件

如果需要完全自定义菜单样式，可以设置 `messageMenuStyle="custom"`，并通过 `MessageCustomLongPressMenu` 属性提供自定义菜单组件：

```typescript
import { ContextNameMenuRef, ContextNameMenuProps } from 'react-native-chat-uikit';

// 自定义菜单组件
const CustomMessageMenu = React.forwardRef<
  ContextNameMenuRef,
  ContextNameMenuProps
>(function (props, ref) {
  // 实现自定义菜单逻辑
  React.useImperativeHandle(ref, () => {
    return {
      startShow: () => {},
      startHide: (onFinished?: () => void) => {},
      startShowWithInit: (initItems, others?) => {},
      startShowWithProps: (props) => {},
      getData: () => undefined,
    };
  }, []);

  return (
    <View>
      {/* 自定义菜单UI */}
    </View>
  );
});

// 使用自定义菜单
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      MessageCustomLongPressMenu: CustomMessageMenu,
    },
  }}
  onBack={() => navigation.goBack()}
/>

// 同时在 UIKitContainer 中设置
<UIKitContainer
  options={options}
  messageMenuStyle="custom"
>
  {/* 应用内容 */}
</UIKitContainer>
```

:::tip
建议使用默认的 `bottom-sheet` 或 `context` 样式，只有在需要完全自定义菜单UI时才使用 `custom` 样式。
:::

## 自定义消息气泡样式

`listItemRenderProps` 是一个非常重要且强大的属性，允许你自定义消息列表中各个组件的渲染方式。通过这个属性，你可以完全控制消息的显示样式，包括消息气泡、消息内容、头像、引用消息等各个部分。

### MessageListItemRenders 组成

`listItemRenderProps` 包含以下可自定义的组件：

| 组件名称              | 类型                           | 描述                                                       |
| --------------------- | ------------------------------ | ---------------------------------------------------------- |
| `MessageView`         | `MessageViewRender`            | 消息视图组件，最外层的消息容器，包含头像、气泡等所有元素。 |
| `MessageBubble`       | `MessageBubbleRender`          | 消息气泡组件，包裹消息内容的气泡背景。                     |
| `MessageContent`      | `MessageContentRender`         | 消息内容组件，显示具体的消息内容（文本、图片、视频等）。   |
| `MessageQuoteBubble`  | `MessageQuoteBubbleRender`     | 引用消息气泡组件，显示被引用的消息内容。                   |
| `MessageThreadBubble` | `MessageThreadRender`          | 话题消息气泡组件，显示话题相关信息。                       |
| `MessageReaction`     | `MessageReactionRender`        | 消息回复表情组件，显示消息的表情回复。                     |
| `SystemTipView`       | `SystemTipViewRender`          | 系统提示组件，显示系统消息（如"xxx 撤回了一条消息"）。     |
| `TimeTipView`         | `TimeTipViewRender`            | 时间提示组件，显示消息时间分隔。                           |
| `ListItemRender`      | `MessageListItemComponentType` | 完整的列表项组件，替换整个消息列表项（包含所有上述组件）。 |

### 自定义消息内容（MessageContent）

`MessageContent` 是最常用的自定义组件，用于自定义消息的显示内容。例如，你可以自定义图片消息的显示方式、添加自定义消息类型等。

#### 基本使用示例

```typescript
import React from 'react';
import { View, Text } from 'react-native';
import {
  MessageContent,
  MessageContentProps,
  ChatMessageType,
  ChatCustomMessageBody,
} from 'react-native-chat-uikit';

// 自定义消息内容组件
export function CustomMessageContent(props: MessageContentProps) {
  const { msg, isSupport } = props;

  // 处理自定义消息类型
  if (msg.body.type === ChatMessageType.CUSTOM) {
    const body = msg.body as ChatCustomMessageBody;

    // 假设你有一个自定义的"安全提示"消息类型
    if (body.event === 'custom_safe_tip') {
      return (
        <View style={{ padding: 10, backgroundColor: '#FFF3E0', borderRadius: 8 }}>
          <Text style={{ color: '#E65100', fontSize: 14 }}>
            {body.params?.tip || '安全提示'}
          </Text>
        </View>
      );
    }

    // 假设你有一个自定义的"红包"消息类型
    if (body.event === 'custom_red_packet') {
      return (
        <View style={{
          padding: 15,
          backgroundColor: '#FF5722',
          borderRadius: 8,
          minWidth: 200,
        }}>
          <Text style={{ color: 'white', fontSize: 16, fontWeight: 'bold' }}>
            🧧 {body.params?.title || '恭喜发财，大吉大利'}
          </Text>
          <Text style={{ color: 'white', fontSize: 12, marginTop: 5 }}>
            {body.params?.subtitle || '点击领取红包'}
          </Text>
        </View>
      );
    }
  }

  // 对于其他消息类型，使用默认渲染
  return <MessageContent {...props} />;
}

// 在 ConversationDetail 中使用
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      listItemRenderProps: {
        MessageContent: CustomMessageContent,
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

#### 自定义图片消息显示

```typescript
import React from 'react';
import { View } from 'react-native';
import {
  MessageContent,
  MessageContentProps,
  ChatMessageType,
  DefaultImage,
  getImageShowSize,
  getImageThumbUrl,
} from 'react-native-chat-uikit';
import FastImage from 'react-native-fast-image'; // 使用第三方图片库

export function CustomMessageContent(props: MessageContentProps) {
  const { msg, contentMaxWidth } = props;
  const [thumbUrl, setThumbUrl] = React.useState<string | undefined>();

  // 自定义图片消息的显示
  if (msg.body.type === ChatMessageType.IMAGE) {
    const { width, height } = getImageShowSize(msg, contentMaxWidth);

    React.useEffect(() => {
      getImageThumbUrl(msg)
        .then((url) => setThumbUrl(url))
        .catch((error) => console.error('加载图片失败:', error));
    }, [msg]);

    return (
      <View
        style={{
          width,
          height,
          borderRadius: 12,
          overflow: 'hidden',
          borderWidth: 1,
          borderColor: '#E0E0E0',
        }}
      >
        <FastImage
          source={{ uri: thumbUrl }}
          style={{ width, height }}
          resizeMode={FastImage.resizeMode.cover}
        />
      </View>
    );
  }

  // 其他消息类型使用默认渲染
  return <MessageContent {...props} />;
}
```

### 自定义消息视图（MessageView）

`MessageView` 是消息的最外层容器，包含了头像、昵称、气泡等所有元素。通过自定义 `MessageView`，你可以控制消息的整体布局。

#### 示例：隐藏左侧消息的头像

```typescript
import React from 'react';
import { MessageView, MessageViewProps } from 'react-native-chat-uikit';

export function CustomMessageView(props: MessageViewProps) {
  // 如果是接收的消息（左侧），隐藏头像
  if (props.model.layoutType === 'left') {
    return <MessageView {...props} avatarIsVisible={false} />;
  }

  // 发送的消息（右侧）保持默认
  return <MessageView {...props} />;
}

// 使用
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      listItemRenderProps: {
        MessageView: CustomMessageView,
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 自定义消息气泡（MessageBubble）

`MessageBubble` 是消息内容的背景气泡，你可以自定义气泡的颜色、圆角、阴影等样式。

```typescript
import React from 'react';
import { View } from 'react-native';
import { MessageBubble, MessageBubbleProps } from 'react-native-chat-uikit';

export function CustomMessageBubble(props: MessageBubbleProps) {
  const { model, children } = props;

  // 自定义发送消息的气泡样式
  if (model.layoutType === 'right') {
    return (
      <View
        style={{
          backgroundColor: '#4CAF50', // 自定义背景色
          borderRadius: 16,
          padding: 12,
          shadowColor: '#000',
          shadowOffset: { width: 0, height: 2 },
          shadowOpacity: 0.1,
          shadowRadius: 4,
          elevation: 2,
        }}
      >
        {children}
      </View>
    );
  }

  // 接收消息使用默认样式
  return <MessageBubble {...props} />;
}
```

### 组合使用多个自定义组件

你可以同时自定义多个组件，实现完整的个性化消息样式：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      listItemRenderProps: {
        // 自定义消息视图
        MessageView: CustomMessageView,
        // 自定义消息气泡
        MessageBubble: CustomMessageBubble,
        // 自定义消息内容
        MessageContent: CustomMessageContent,
        // 自定义系统提示
        SystemTipView: CustomSystemTipView,
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 实际项目示例

参考 product-uikit-demo 中的实现：

```typescript
// 自定义图片组件，使用 FastImage 优化性能
export function DemoMessageImage(props: MessageImageProps) {
  const { msg, maxWidth } = props;
  const [thumbUrl, setThumbUrl] = React.useState<string | undefined>();
  const { width, height } = getImageShowSize(msg, maxWidth);

  React.useEffect(() => {
    getImageThumbUrl(msg)
      .then((url) => setThumbUrl(url))
      .catch((error) => console.error(error));
  }, [msg]);

  return (
    <DemoMessageDefaultImage
      url={thumbUrl}
      width={width}
      height={height}
      thumbWidth={64}
      thumbHeight={64}
      iconName={'img'}
    />
  );
}

// 自定义消息内容组件
export function DemoMessageContent(props: MessageContentProps) {
  const { msg, isSupport, layoutType, contentMaxWidth, ...others } = props;

  // 处理图片消息
  if (isSupport === true) {
    if (msg.body.type === ChatMessageType.IMAGE) {
      return (
        <DemoMessageImage
          layoutType={layoutType}
          msg={msg}
          maxWidth={contentMaxWidth}
          {...others}
        />
      );
    }
  }

  // 其他消息类型使用默认渲染
  return <MessageContent {...props} />;
}

// 在聊天页面中使用
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  list={{
    props: {
      listItemRenderProps: {
        MessageContent: DemoMessageContent,
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```

### 注意事项

- 使用 `React.memo` 包裹自定义组件
- 避免在组件内部进行复杂计算
- 合理使用 `useMemo` 和 `useCallback`

## 使用控制器

通过获取 `MessageListRef` 引用，可以使用控制器方法实现更多高级功能。

### 添加消息到列表

通过控制器的 `addSendMessage` 方法可以添加消息到列表：

```typescript
import React, { useRef } from 'react';
import type { MessageListRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const messageListRef = useRef<MessageListRef>(null);

  const handleAddMessage = () => {
    messageListRef.current?.addSendMessage({
      type: 'text',
      content: 'Hello, World!',
    });
  };

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType}
      list={{
        ref: messageListRef,
      }}
      onBack={() => navigation.goBack()}
    />
  );
}
```

也可以使用 `addSendMessageToUI` 方法，它提供了更多的控制选项：

```typescript
const handleAddMessageWithCallback = async () => {
  await messageListRef.current?.addSendMessageToUI({
    value: {
      type: "text",
      content: "Hello!",
    },
    onBeforeCallback: async () => {
      console.log("添加消息前的准备工作");
    },
    onFinished: (item) => {
      console.log("消息已添加到UI:", item);
    },
  });
};
```

### 移除消息

通过控制器的 `removeMessage` 方法可以移除消息：

```typescript
const handleRemoveMessage = (message: ChatMessage) => {
  messageListRef.current?.removeMessage(message);
};
```

### 撤回消息

通过控制器的 `recallMessage` 方法可以撤回消息：

```typescript
const handleRecallMessage = (message: ChatMessage) => {
  messageListRef.current?.recallMessage(message);
};
```

### 更新消息

通过控制器的 `updateMessage` 方法可以更新消息：

```typescript
const handleUpdateMessage = (updatedMessage: ChatMessage) => {
  messageListRef.current?.updateMessage(updatedMessage, "send");
  // 第二个参数: 'send' 表示发送的消息，'recv' 表示接收的消息
};
```

### 滚动到底部

通过控制器的 `scrollToBottom` 方法可以滚动到列表底部：

```typescript
const handleScrollToBottom = () => {
  messageListRef.current?.scrollToBottom();
};
```

### 多选消息操作

通过控制器可以实现多选消息的操作：

```typescript
// 取消多选模式
const handleCancelMultiSelect = () => {
  messageListRef.current?.cancelMultiSelected();
};

// 删除多选的消息
const handleRemoveMultiSelected = () => {
  messageListRef.current?.removeMultiSelected((confirmed) => {
    if (confirmed) {
      console.log("用户确认删除");
    } else {
      console.log("用户取消删除");
    }
  });
};

// 获取多选的消息列表
const handleGetMultiSelected = () => {
  const messages = messageListRef.current?.getMultiSelectedMessages() || [];
  console.log("选中的消息:", messages);
};
```

### 置顶消息操作

通过控制器可以控制置顶消息组件的显示和隐藏（仅群聊支持）：

```typescript
// 显示置顶消息组件
const handleShowPinMessage = () => {
  messageListRef.current?.showPinMessageComponent();
};

// 隐藏置顶消息组件
const handleHidePinMessage = () => {
  messageListRef.current?.hidePinMessageComponent();
};

// 请求显示置顶消息组件（根据置顶消息数量决定是否显示）
const handleRequestShowPinMessage = () => {
  messageListRef.current?.requestShowPinMessageComponent((count) => {
    console.log("置顶消息数量:", count);
    // 可以根据数量决定是否显示
  });
};
```

## MessageListRef 控制器方法

`MessageListRef` 提供以下控制器方法：

| 方法名                           | 参数                                                  | 返回值          | 描述                                                   |
| -------------------------------- | ----------------------------------------------------- | --------------- | ------------------------------------------------------ |
| `addSendMessage`                 | `value: SendMessageProps`                             | `void`          | 添加消息到列表底部位置。                               |
| `addSendMessageToUI`             | `params: {value, onFinished?, onBeforeCallback?}`     | `Promise<void>` | 添加消息到 UI，并提供回调。                            |
| `sendMessageToServer`            | `msg: ChatMessage`                                    | `void`          | 将消息发送到服务器。                                   |
| `saveMessage`                    | `msg: ChatMessage`                                    | `void`          | 将消息保存到本地数据库。                               |
| `removeMessage`                  | `msg: ChatMessage`                                    | `void`          | 从消息列表中移除消息。                                 |
| `recallMessage`                  | `msg: ChatMessage`                                    | `void`          | 撤回消息。                                             |
| `updateMessage`                  | `updatedMsg: ChatMessage, fromType: 'send' \| 'recv'` | `void`          | 更新消息。                                             |
| `loadHistoryMessage`             | `msgs: ChatMessage[], pos: 'top' \| 'bottom'`         | `void`          | 加载历史消息到指定位置。                               |
| `onInputHeightChange`            | `height: number`                                      | `void`          | 输入组件高度变化时的回调通知。                         |
| `editMessageFinished`            | `model: MessageModel`                                 | `void`          | 消息编辑完成时的回调通知。                             |
| `scrollToBottom`                 | 无                                                    | `void`          | 滚动列表到底部。                                       |
| `startShowThreadMoreMenu`        | 无                                                    | `void`          | 显示话题更多菜单。                                     |
| `cancelMultiSelected`            | 无                                                    | `void`          | 取消多选模式。                                         |
| `removeMultiSelected`            | `onResult: (confirmed: boolean) => void`              | `void`          | 移除多选的消息。                                       |
| `getMultiSelectedMessages`       | 无                                                    | `ChatMessage[]` | 获取多选的消息列表。                                   |
| `showPinMessageComponent`        | 无                                                    | `void`          | 显示置顶消息组件。                                     |
| `hidePinMessageComponent`        | 无                                                    | `void`          | 隐藏置顶消息组件。                                     |
| `requestShowPinMessageComponent` | `onResult: (count: number) => void`                   | `void`          | 请求显示置顶消息组件，可根据置顶消息数量决定是否显示。 |

## 图标说明

*菜单图标修改参考图标自定义文档。*

### 消息上下文菜单图标

长按消息气泡弹出的上下文菜单使用以下默认图标：

| 功能     | 图标名称                     | 描述         |
| -------- | ---------------------------- | ------------ |
| 复制消息 | `doc_on_doc`                 | 复制消息内容 |
| 转发消息 | `arrowshape_right`           | 转发消息     |
| 创建话题 | `hashtag_in_bubble_fill`     | 创建话题     |
| 回复消息 | `arrowshape_left`            | 回复消息     |
| 撤回消息 | `arrow_Uturn_anti_clockwise` | 撤回消息     |
| 编辑消息 | `slash_in_rectangle`         | 编辑消息     |
| 多选消息 | `check_n_3lines`             | 多选消息     |
| 置顶消息 | `pin_2`                      | 置顶消息     |
| 翻译消息 | `a_in_arrows_round`          | 翻译消息     |
| 上报消息 | `envelope`                   | 举报消息     |
| 删除消息 | `trash`                      | 删除消息     |

### 消息状态图标

消息列表中显示的消息状态图标：

| 状态             | 图标名称                      | 描述               |
| ---------------- | ----------------------------- | ------------------ |
| 发送中           | `loading`                     | 消息正在发送       |
| 已送达           | `check`                       | 消息已送达服务器   |
| 发送失败         | `exclamation_mark_in_circle`  | 消息发送失败       |
| 已读回执         | `check_2`                     | 消息已被对方阅读   |
| 语音未播放状态   | `dot_1`                       | 语音消息未播放标识 |

## 相关文档

- [聊天页面介绍](chatuikit_custom_chat_intro.html)
- [聊天页面的基本设置](chatuikit_custom_chat_basic.html)
- [设置消息输入组件](chatuikit_custom_chat_message_input.html)
