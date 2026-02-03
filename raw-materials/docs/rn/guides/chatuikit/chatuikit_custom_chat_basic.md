# 聊天页面的基本设置

本文介绍如何通过 `ConversationDetail` 组件实现聊天页面的基本设置，包括标题栏显示、消息发送、点击事件监听等常用功能。

## 概述

`ConversationDetail` 组件是一个复合组件，主要用于显示单聊和群聊的聊天内容。该组件内部包含了消息列表组件（`MessageList`）、消息输入组件（`MessageInput`）以及标题栏等子组件。

`ConversationDetail` 组件支持以下基本自定义设置:

- [聊天页面的基本设置](#聊天页面的基本设置)
  - [概述](#概述)
  - [基本使用](#基本使用)
  - [显示或隐藏标题栏](#显示或隐藏标题栏)
  - [设置背景图片](#设置背景图片)
  - [设置容器样式](#设置容器样式)
  - [设置点击事件](#设置点击事件)
    - [点击头像](#点击头像)
    - [点击话题](#点击话题)
    - [点击音视频通话](#点击音视频通话)
  - [使用控制器](#使用控制器)
    - [发送名片消息](#发送名片消息)
    - [切换消息选择模式](#切换消息选择模式)
  - [ConversationDetailRef 控制器方法](#conversationdetailref-控制器方法)
  - [图标说明](#图标说明)
  - [相关文档](#相关文档)

## 基本使用

使用示例如下：

```typescript
import { ConversationDetail } from 'react-native-chat-uikit';
import type { ChatConversationType } from 'react-native-chat-sdk';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;

  return (
    <ConversationDetail
      type="chat"
      convId={convId}
      convType={convType as ChatConversationType}
      onBack={() => {
        navigation.goBack();
      }}
    />
  );
}
```

`ConversationDetail` 组件基本属性如下表所示：

| 属性                     | 类型                                     | 是否必需 | 描述                                                                                                                                                                                                                        |
| ------------------------ | ---------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `type`                   | `ConversationDetailModelType`            | 是       | 聊天页面的类型。<br/> - `chat`：普通聊天页面。<br/> - `create_thread`：创建话题页面。<br/> - `thread`：话题聊天页面。<br/> - `search`：搜索消息页面。                                                                       |
| `convId`                 | `string`                                 | 是       | 会话 ID。                                                                                                                                                                                                                   |
| `convType`               | `ChatConversationType`                   | 是       | 会话类型。<br/> - `PeerChat`（0）：单聊。<br/> - `GroupChat`（1）：群聊。                                                                                                                                                   |
| `onBack`                 | `() => void`                             | 否       | 返回按钮的回调。                                                                                                                                                                                                            |
| `enableNavigationBar`    | `boolean`                                | 否       | 是否显示标题栏。<br/> - `true`（默认）：显示。<br/> - `false`：隐藏。<br/> 详见[显示或隐藏标题栏](#显示或隐藏标题栏)。                                                                                                      |
| `NavigationBar`          | `TopNavigationBarElementType`            | 否       | 自定义标题栏组件，完整替换默认标题栏。<br/> 详见 [设置页面标题栏](chatuikit_custom_titlebar.html)。                                                                                                                         |
| `containerStyle`         | `StyleProp<ViewStyle>`                   | 否       | 聊天页面容器的样式。                                                                                                                                                                                                        |
| `backgroundImage`        | `ImageSourcePropType`                    | 否       | 聊天页面的背景图片。详见[设置背景图片](#设置背景图片)。                                                                                                                                                                     |
| `backgroundImageStyle`   | `StyleProp<ImageStyle>`                  | 否       | 背景图片的样式。                                                                                                                                                                                                            |
| `onClickedAvatar`        | `(params) => void`                       | 否       | 点击头像的回调。详见[点击头像](#点击头像)。                                                                                                                                                                                 |
| `onClickedThread`        | `() => void`                             | 否       | 点击话题按钮的回调。详见[点击话题](#点击话题)。                                                                                                                                                                             |
| `onClickedVoice`         | `() => void`                             | 否       | 点击语音通话按钮的回调。详见[点击音视频通话](#点击音视频通话)。                                                                                                                                                             |
| `onClickedVideo`         | `() => void`                             | 否       | 点击视频通话按钮的回调。详见[点击音视频通话](#点击音视频通话)。                                                                                                                                                             |
| `propsRef`               | `React.RefObject<ConversationDetailRef>` | 否       | 聊天页面组件的控制器引用。详见[使用控制器](#使用控制器)。                                                                                                                                                                   |
| `input`                  | `{props, render, ref}`                   | 否       | 自定义消息输入组件的配置对象。<br/> - `props`：传递给消息输入组件的属性。<br/> - `render`：自定义消息输入组件。<br/> - `ref`：消息输入组件的引用。<br/> 详见 [设置消息输入组件](chatuikit_custom_chat_message_input.html)。 |
| `list`                   | `{props, render, ref}`                   | 否       | 自定义消息列表组件的配置对象。<br/> - `props`：传递给消息列表组件的属性。<br/> - `render`：自定义消息列表组件。<br/> - `ref`：消息列表组件的引用。<br/> 详见 [设置消息列表组件](chatuikit_custom_chat_message_list.html)。  |
| `onForwardMessage`       | `(msgs: ChatMessage[]) => void`          | 否       | 转发消息的回调，通常需要跳转到联系人选择页面。                                                                                                                                                                              |
| `onThreadDestroyed`      | `(thread: ChatMessageThread) => void`    | 否       | 话题被销毁的回调。                                                                                                                                                                                                          |
| `onThreadKicked`         | `(thread: ChatMessageThread) => void`    | 否       | 被移出话题的回调。                                                                                                                                                                                                          |
| `onCreateThreadResult`   | `(thread?, firstMessage?) => void`       | 否       | 创建话题结果的回调。                                                                                                                                                                                                        |
| `MessageCustomLongPress` | `React.ForwardRefExoticComponent<...>`   | 否       | 自定义消息长按菜单组件。                                                                                                                                                                                                    |
| `thread`                 | `ChatMessageThread`                      | 否       | 话题对象，当 `type` 为 `thread` 或 `create_thread` 时需要提供。                                                                                                                                                             |
| `msgId`                  | `string`                                 | 否       | 消息 ID，当 `type` 为 `create_thread` 时需要提供。                                                                                                                                                                          |
| `parentId`               | `string`                                 | 否       | 父级 ID（通常是群组 ID），当 `type` 为 `create_thread` 时需要提供。                                                                                                                                                         |
| `newThreadName`          | `string`                                 | 否       | 新话题的名称，当 `type` 为 `create_thread` 时需要提供。                                                                                                                                                                     |
| `firstMessage`           | `SendMessageProps`                       | 否       | 第一条消息，当 `type` 为 `thread` 时需要提供。                                                                                                                                                                              |
| `selectType`             | `ConversationSelectModeType`             | 否       | 消息选择模式。<br/> - `common`（默认）：普通模式。<br/> - `multi`：多选模式。<br/> **注意**: 此属性主要用于内部组件之间通信，一般用户无需关注。建议通过控制器的 `changeSelectType` 方法切换模式。                           |

:::tip
React Native 的 UIKit 没有内置路由跳转功能，涉及页面跳转的操作（如转发消息、创建话题等）需要通过回调函数自行处理。
:::

## 显示或隐藏标题栏

`ConversationDetail` 组件通过 `enableNavigationBar` 属性控制标题栏的显示。

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  enableNavigationBar={true}  // 显示标题栏（默认）
  onBack={() => navigation.goBack()}
/>

<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  enableNavigationBar={false}  // 隐藏标题栏
  onBack={() => navigation.goBack()}
/>
```

如果需要完全自定义标题栏，可以使用 `NavigationBar` 属性：

```typescript
import { TopNavigationBar } from 'react-native-chat-uikit';

<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  NavigationBar={(props) => (
    <TopNavigationBar
      {...props}
      Left={
        <Text style={{ color: 'white' }}>自定义返回</Text>
      }
    />
  )}
  onBack={() => navigation.goBack()}
/>
```

详见 [设置页面标题栏](chatuikit_custom_titlebar.html)。

## 设置背景图片

通过 `backgroundImage` 和 `backgroundImageStyle` 属性可以自定义聊天页面的背景图片：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  backgroundImage={require('./assets/chat_background.png')}
  backgroundImageStyle={{
    opacity: 0.3,
    resizeMode: 'cover',
  }}
  onBack={() => navigation.goBack()}
/>
```

也可以使用网络图片：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  backgroundImage={{ uri: 'https://example.com/background.jpg' }}
  onBack={() => navigation.goBack()}
/>
```

## 设置容器样式

通过 `containerStyle` 属性可以自定义聊天页面容器的样式：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  containerStyle={{
    backgroundColor: '#f5f5f5',
  }}
  onBack={() => navigation.goBack()}
/>
```

## 设置点击事件

### 点击头像

通过 `onClickedAvatar` 处理标题栏头像的点击事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  onClickedAvatar={(params) => {
    const { convId, convType, ownerId } = params;
    console.log('点击头像:', convId, convType, ownerId);

    // 跳转到用户详情或群组详情页面
    if (convType === ChatConversationType.PeerChat) {
      navigation.navigate('UserDetail', { userId: convId });
    } else {
      navigation.navigate('GroupDetail', { groupId: convId });
    }
  }}
  onBack={() => navigation.goBack()}
/>
```

参数说明：

- `convId`: 会话 ID
- `convType`: 会话类型
- `ownerId`: 所有者 ID（如果是群聊，表示消息发送者的 ID）

### 点击话题

通过 `onClickedThread` 处理话题按钮的点击事件（仅群聊有效）：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  onClickedThread={() => {
    console.log('点击话题按钮');
    // 跳转到话题列表页面
    navigation.navigate('ThreadList', { groupId: convId });
  }}
  onBack={() => navigation.goBack()}
/>
```

### 点击音视频通话

通过 `onClickedVoice` 和 `onClickedVideo` 处理音视频通话按钮的点击事件：

```typescript
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  onClickedVoice={() => {
    console.log('发起语音通话');
    // 调用语音通话功能
    startVoiceCall(convId);
  }}
  onClickedVideo={() => {
    console.log('发起视频通话');
    // 调用视频通话功能
    startVideoCall(convId);
  }}
  onBack={() => navigation.goBack()}
/>
```

:::note
音视频通话功能需要集成 CallKit 组件，详见相关文档。
:::

## 使用控制器

通过 `propsRef` 属性可以获取聊天页面组件的控制器，实现更多高级功能。

### 发送名片消息

通过控制器的 `sendCardMessage` 方法可以发送名片消息：

```typescript
import React, { useRef } from 'react';
import type { ConversationDetailRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const detailRef = useRef<ConversationDetailRef>(null);

  const handleSendCard = () => {
    detailRef.current?.sendCardMessage({
      type: 'card',
      userId: 'user123',
      nickname: '张三',
      avatar: 'https://example.com/avatar.jpg',
    });
  };

  return (
    <>
      <ConversationDetail
        type="chat"
        convId={convId}
        convType={convType}
        propsRef={detailRef}
        onBack={() => navigation.goBack()}
      />
      <Button title="发送名片" onPress={handleSendCard} />
    </>
  );
}
```

### 切换消息选择模式

通过控制器的 `changeSelectType` 方法可以切换消息选择模式（普通模式和多选模式）：

```typescript
import React, { useRef } from 'react';
import type { ConversationDetailRef } from 'react-native-chat-uikit';

function ChatScreen({ route }) {
  const { convId, convType } = route.params;
  const detailRef = useRef<ConversationDetailRef>(null);

  const enableMultiSelect = () => {
    // 切换到多选模式
    detailRef.current?.changeSelectType('multi');
  };

  const disableMultiSelect = () => {
    // 切换回普通模式
    detailRef.current?.changeSelectType('common');
  };

  return (
    <>
      <ConversationDetail
        type="chat"
        convId={convId}
        convType={convType}
        propsRef={detailRef}
        onBack={() => navigation.goBack()}
      />
      <View style={{ flexDirection: 'row' }}>
        <Button title="开启多选" onPress={enableMultiSelect} />
        <Button title="关闭多选" onPress={disableMultiSelect} />
      </View>
    </>
  );
}
```

多选模式下，用户可以选择多条消息进行批量操作（如删除、转发等）。

## ConversationDetailRef 控制器方法

`ConversationDetailRef` 提供以下控制器方法：

| 方法名             | 参数                               | 返回值 | 描述                                                                      |
| ------------------ | ---------------------------------- | ------ | ------------------------------------------------------------------------- |
| `sendCardMessage`  | `props: SendCardProps`             | `void` | 发送名片消息。参数包括名片的用户 ID、昵称、头像等信息。                   |
| `changeSelectType` | `type: ConversationSelectModeType` | `void` | 切换消息选择模式。<br/> - `common`：普通模式。<br/> - `multi`：多选模式。 |

## 图标说明

*图标修改参考图标自定义文档。*

聊天页面标题栏使用以下默认图标：

| 功能           | 图标名称                 | 描述                   |
| -------------- | ------------------------ | ---------------------- |
| 置顶           | `pin_2`                  | 置顶消息或会话         |
| 话题           | `hashtag_in_bubble_fill` | 创建或查看话题         |
| 音频通话       | `phone_pick`             | 发起语音通话           |
| 视频通话       | `video_camera`           | 发起视频通话           |
| 音视频通话     | `phonen_camera`          | 发起音视频通话（通用） |
| 更多菜单（省略号） | `ellipsis_vertical`      | 打开更多操作菜单       |

## 相关文档

- [设置页面标题栏](chatuikit_custom_titlebar.html)
- [设置消息列表组件](chatuikit_custom_chat_message_list.html)
- [设置消息输入组件](chatuikit_custom_chat_message_input.html)
- [聊天页面介绍](chatuikit_custom_chat_intro.html)
