# 聊天页面介绍

环信单群聊 UIKit 提供 `ConversationDetail` 组件加载聊天页面。该页面提供如下功能：

- 发送和接收消息, 包括文本、表情、图片、语音、视频、文件和名片消息。
- 对消息进行复制、引用、撤回、删除、编辑、重新发送和审核。
- 清除本地消息。

## 页面组件

聊天页面通过 `ConversationDetail` 实现，由标题栏 `ConversationDetailNavigationBar`、消息列表 `MessageList` 和底部输入框 `MessageInput` 组成。

<ImageGallery>
  <ImageItem src="/images/uikit/chatuikit/android/custom_chat.png" title="聊天页面 ConversationDetail" />
</ImageGallery>

### 组件结构

聊天页面组件是一个复杂的组件，主要包含以下子组件：

- **ConversationDetail**：聊天页面主组件
  - **ConversationDetailNavigationBar**：标题栏组件
  - **MessageList**：消息列表组件
    - **AnimatedMessagePinPlaceholder**：消息置顶占位组件
    - **FlatList**：消息列表渲染组件
    - **MessageLongPressMenu**：消息长按上下文菜单
    - **BottomSheetEmojiList**：消息回应表情选择组件
    - **BottomSheetReactionDetail**：消息回应详情组件
    - **BottomSheetMessageReport**：消息举报组件
  - **MessageInput**：消息输入组件
    - **EmojiList**：表情选择列表组件
    - **BottomVoiceBar**：语音输入栏组件
    - **MessageInputEditMessage**：编辑消息输入组件
  - **BottomSheetNameMenu**：底部菜单组件

### 标题栏

聊天页面的标题栏使用 `ConversationDetailNavigationBar` 组件，该组件基于通用的 `TopNavigationBar` 实现，支持显示会话名称、头像、免打扰状态等信息，并提供返回、音视频通话、更多操作等功能。详见 [设置标题栏](chatuikit_custom_titlebar.html)。

### 消息列表

消息列表 `MessageList` 用于展示发送和接收的消息，以及对消息进行操作：

- **展示消息**：支持文本、表情、图片、语音、视频、文件和名片等多种类型的消息展示。
- **消息操作**：通过长按消息可以进行复制、引用、撤回、删除、编辑、重新发送、举报、翻译、转发、多选、置顶等操作。
- **消息回应**：支持对消息进行表情回应（Reaction），点击回应可查看回应详情。
- **消息置顶**：支持群聊消息置顶功能，置顶的消息会显示在列表顶部。
- **消息条目**：`MessageListItem` 实现单条消息展示，包括消息气泡、用户头像、消息时间、发送状态等。

#### 消息列表子组件

- **AnimatedMessagePinPlaceholder**：消息置顶占位组件，为置顶消息预留显示空间。
- **MessageLongPressMenu**：消息长按菜单，提供消息操作选项。
- **BottomSheetEmojiList**：表情回应选择器，用于选择对消息的回应表情。
- **BottomSheetReactionDetail**：表情回应详情，显示消息的所有回应及回应用户。
- **BottomSheetMessageReport**：消息举报弹窗，用于举报不当消息。

### 消息输入

消息输入组件 `MessageInput` 实现各类消息的输入和发送功能，主要包括：

- **文本输入**：支持多行文本输入，自动调节输入框高度。
- **语音消息**：通过 `BottomVoiceBar` 实现语音消息的录制和发送。
- **表情选择**：通过 `EmojiList` 组件选择和发送表情。
- **扩展功能**：通过扩展菜单发送图片、视频、文件、名片等附件类型消息。
- **消息编辑**：通过 `MessageInputEditMessage` 组件编辑已发送的消息。
- **消息引用**：支持引用其他消息进行回复。
- **多选模式**：支持多选消息进行批量删除或转发操作。

#### 消息输入子组件

- **EmojiList**：表情选择列表，提供常用表情的选择和发送。
- **BottomVoiceBar**：语音输入栏，支持按住说话、松开发送的语音消息录制。
- **MessageInputEditMessage**：编辑消息弹窗，用于编辑已发送的文本消息。
- **MessageInputBarMenu**：扩展功能菜单，提供图片、视频、文件、名片等附件发送功能。

## 创建聊天页面

使用单群聊 UIKit 提供的 `ConversationDetail` 组件创建聊天页面。React Native UIKit 不内置路由跳转功能，需要开发者自行集成导航库（如 React Navigation）进行页面跳转。

示例代码如下：

```tsx
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import * as React from 'react';
import { View } from 'react-native';
import {
  ConversationDetail,
  type ConversationDetailModelType,
  type ConversationDetailRef,
} from 'react-native-chat-uikit';

type Props = NativeStackScreenProps<RootScreenParamsList>;

export function ConversationDetailScreen(props: Props) {
  const { route, navigation } = props;
  const convId = ((route.params as any)?.params as any)?.convId;
  const convType = ((route.params as any)?.params as any)?.convType;
  const convRef = React.useRef<ConversationDetailRef>({} as any);

  return (
    <ConversationDetail
      type={'chat'}
      convId={convId}
      convType={convType}
      onBack={() => {
        navigation.goBack();
      }}
    />
  );
}
```

### 参数说明

- `type`：聊天页面类型，可选值：
  - `'chat'`：普通聊天页面
  - `'thread'`：话题聊天页面
  - `'search'`：消息搜索历史页面
  - `'create_thread'`：创建话题页面
- `convId`：会话 ID
- `convType`：会话类型，0 表示单聊，1 表示群聊
- `onBack`：返回按钮点击回调，用于页面导航
- `enableNavigationBar`：是否显示导航栏，默认为 `true`
- `NavigationBar`：自定义导航栏组件