# 消息置顶组件

本文介绍如何使用 `MessagePin` 组件实现消息置顶功能，包括显示置顶消息列表、点击置顶消息等操作。

## 概述

`MessagePin` 组件是一个用于显示和管理会话中置顶消息的组件。该组件提供了一个可展开/收起的置顶消息列表面板，支持查看所有置顶消息、点击定位到消息、删除置顶等功能。

`MessagePin` 组件支持以下自定义设置：

- [消息置顶组件](#消息置顶组件)
  - [概述](#概述)
  - [基本使用](#基本使用)
  - [组件控制方法](#组件控制方法)
    - [显示置顶面板](#显示置顶面板)
    - [隐藏置顶面板](#隐藏置顶面板)
    - [添加置顶消息](#添加置顶消息)
    - [注册点击回调](#注册点击回调)
  - [设置容器样式](#设置容器样式)
  - [处理关闭操作](#处理关闭操作)
  - [图标说明](#图标说明)
  - [相关文档](#相关文档)

## 基本使用

`MessagePin` 组件通常不直接单独使用，而是作为 `MessageList` 组件的一部分集成在聊天页面中。但如果需要单独使用，可以参考以下示例：

```typescript
import React, { useRef } from 'react';
import { MessagePin } from 'react-native-chat-uikit';
import { Animated } from 'react-native';

function ChatScreen() {
  const msgPinRef = useRef<MessagePin>(null);
  const msgPinHeightRef = useRef(0);
  const msgPinLabelTranslateYRef = useRef(0);
  
  const msgPinCurrentHeight = useRef(new Animated.Value(0)).current;
  const msgPinLabelCurrentTranslateY = useRef(new Animated.Value(0)).current;
  const msgPinBackgroundCurrentOpacity = useRef(new Animated.Value(0)).current;

  const msgPinHeightAnimate = (toValue: number, onFinished?: () => void) => {
    Animated.timing(msgPinCurrentHeight, {
      toValue,
      duration: 250,
      useNativeDriver: false,
    }).start(onFinished);
  };

  const msgPinLabelTranslateYAnimate = (toValue: number, onFinished?: () => void) => {
    Animated.timing(msgPinLabelCurrentTranslateY, {
      toValue,
      duration: 250,
      useNativeDriver: true,
    }).start(onFinished);
  };

  const msgPinBackgroundOpacityAnimate = (toValue: number, onFinished?: () => void) => {
    Animated.timing(msgPinBackgroundCurrentOpacity, {
      toValue,
      duration: 250,
      useNativeDriver: true,
    }).start(onFinished);
  };

  const msgPinPlaceHolderHeightAnimate = (toValue: number, onFinished?: () => void) => {
    // 处理占位符高度动画
  };

  return (
    <MessagePin
      ref={msgPinRef}
      convId="conversationId"
      convType={0}
      msgPinHeightRef={msgPinHeightRef}
      msgPinHeightAnimate={msgPinHeightAnimate}
      msgPinLabelTranslateYRef={msgPinLabelTranslateYRef}
      msgPinLabelTranslateYAnimate={msgPinLabelTranslateYAnimate}
      msgPinBackgroundOpacityAnimate={msgPinBackgroundOpacityAnimate}
      msgPinPlaceHolderHeightAnimate={msgPinPlaceHolderHeightAnimate}
      msgPinLabelCurrentTranslateY={msgPinLabelCurrentTranslateY}
      msgPinBackgroundCurrentOpacity={msgPinBackgroundCurrentOpacity}
      msgPinCurrentHeight={msgPinCurrentHeight}
      panHandlers={{}}
      onRequestClose={() => {
        msgPinRef.current?.hide();
      }}
    />
  );
}
```

`MessagePin` 组件属性如下表所示：

| 属性                             | 类型                                                        | 是否必需 | 描述                                                                                        |
| -------------------------------- | ----------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------- |
| `convId`                         | `string`                                                    | 是       | 会话 ID。                                                                                   |
| `convType`                       | `number`                                                    | 是       | 会话类型。<br/> - `0`：单聊。<br/> - `1`：群聊。                                            |
| `style`                          | `StyleProp<ViewStyle>`                                      | 否       | 容器的样式。详见[设置容器样式](#设置容器样式)。                                             |
| `msgPinHeightRef`                | `React.MutableRefObject<number>`                            | 是       | 置顶面板当前高度的引用。                                                                    |
| `msgPinHeightAnimate`            | `(toValue: number, onFinished?: () => void) => void`        | 是       | 置顶面板高度动画函数。                                                                      |
| `msgPinLabelTranslateYRef`       | `React.MutableRefObject<number>`                            | 是       | 置顶标签垂直位移的引用。                                                                    |
| `msgPinLabelTranslateYAnimate`   | `(toValue: number, onFinished?: () => void) => void`        | 是       | 置顶标签垂直位移动画函数。                                                                  |
| `msgPinBackgroundOpacityAnimate` | `(toValue: number, onFinished?: () => void) => void`        | 是       | 背景遮罩透明度动画函数。                                                                    |
| `msgPinPlaceHolderHeightAnimate` | `(toValue: number, onFinished?: () => void) => void`        | 是       | 占位符高度动画函数。                                                                        |
| `msgPinLabelCurrentTranslateY`   | `Animated.Value`                                            | 是       | 置顶标签当前垂直位移的动画值。                                                              |
| `msgPinBackgroundCurrentOpacity` | `Animated.Value`                                            | 是       | 背景遮罩当前透明度的动画值。                                                                |
| `msgPinCurrentHeight`            | `Animated.Value`                                            | 是       | 置顶面板当前高度的动画值。                                                                  |
| `panHandlers`                    | `GestureResponderHandlers`                                  | 是       | 手势处理器，用于处理拖动等手势操作。                                                        |
| `onChangePinMaskHeight`          | `(height: number) => void`                                  | 否       | 置顶遮罩高度变化时的回调。                                                                  |
| `onRequestClose`                 | `() => void`                                                | 否       | 请求关闭置顶面板的回调。通常在点击遮罩或关闭按钮时触发。详见[处理关闭操作](#处理关闭操作)。 |

:::tip
`MessagePin` 组件需要配合多个动画参数使用，这些参数通常由父组件（如 `MessageList`）管理。一般情况下，不建议单独使用该组件，而是通过 `MessageList` 组件的置顶功能来间接使用。
:::

## 组件控制方法

`MessagePin` 组件是一个类组件，提供了以下公共方法来控制置顶面板的行为：

### 显示置顶面板

使用 `show()` 方法显示置顶面板：

```typescript
const msgPinRef = useRef<MessagePin>(null);

// 显示置顶面板
msgPinRef.current?.show();
```

该方法会触发以下动画效果：
- 展开置顶面板到完整高度
- 显示背景遮罩
- 展示置顶消息标签
- 显示占位符

### 隐藏置顶面板

使用 `hide()` 方法隐藏置顶面板：

```typescript
const msgPinRef = useRef<MessagePin>(null);

// 隐藏置顶面板
msgPinRef.current?.hide();
```

该方法会触发以下动画效果：
- 收起置顶面板到零高度
- 隐藏背景遮罩
- 隐藏置顶消息标签
- 隐藏占位符

### 添加置顶消息

使用 `addPinMessage(msg)` 方法添加一条置顶消息到列表中：

```typescript
import { ChatMessage } from 'react-native-chat-sdk';

const msgPinRef = useRef<MessagePin>(null);

// 添加置顶消息
const message: ChatMessage = {
  // ... 消息对象
};
msgPinRef.current?.addPinMessage(message);
```

当有新消息被置顶时，可以通过此方法将其添加到置顶列表中。

### 注册点击回调

使用 `registerCallback(onClickedItem)` 方法注册置顶消息项的点击回调：

```typescript
import { ChatMessage } from 'react-native-chat-sdk';

const msgPinRef = useRef<MessagePin>(null);

// 注册点击回调
msgPinRef.current?.registerCallback((msg: ChatMessage) => {
  console.log('点击置顶消息:', msg.msgId);
  // 定位到该消息
  // messageListRef.current?.scrollToMessage(msg.msgId);
});
```

## 设置容器样式

通过 `style` 属性可以自定义置顶面板容器的样式：

```typescript
<MessagePin
  convId={convId}
  convType={convType}
  style={{
    backgroundColor: '#ffffff',
    borderRadius: 8,
  }}
  // ... 其他必需属性
/>
```

## 处理关闭操作

通过 `onRequestClose` 回调处理置顶面板的关闭请求。通常在以下情况会触发：
- 点击背景遮罩
- 点击关闭按钮

```typescript
<MessagePin
  convId={convId}
  convType={convType}
  onRequestClose={() => {
    console.log('请求关闭置顶面板');
    // 隐藏置顶面板
    msgPinRef.current?.hide();
  }}
  // ... 其他必需属性
/>
```

## 图标说明

消息置顶组件使用以下图标：

- `pin_2`: 置顶图标，显示在置顶面板的标题处

这些图标可以通过 UIKit 的主题系统进行自定义。详见[自定义图标](chatuikit_custom_icon.html)。

## 相关文档

- [聊天页面介绍](chatuikit_custom_chat_intro.html)
- [聊天页面基本设置](chatuikit_custom_chat_basic.html)
- [消息列表组件](chatuikit_custom_chat_message_list.html)
- [自定义图标](chatuikit_custom_icon.html)
