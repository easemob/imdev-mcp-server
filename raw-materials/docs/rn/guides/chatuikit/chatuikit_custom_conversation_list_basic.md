# 会话列表的基本设置

本文介绍如何通过 `ConversationList` 组件实现会话列表的基本设置，包括标题栏显示、搜索样式、点击事件监听等常用功能。

## 概述

`ConversationList` 组件支持以下基本自定义设置：

- [会话列表的基本设置](#会话列表的基本设置)
  - [概述](#概述)
  - [显示或隐藏标题栏](#显示或隐藏标题栏)
  - [显示或隐藏搜索样式](#显示或隐藏搜索样式)
  - [设置容器样式](#设置容器样式)
  - [设置点击事件](#设置点击事件)
    - [点击会话条目](#点击会话条目)
    - [长按会话条目](#长按会话条目)
  - [处理新会话创建](#处理新会话创建)
  - [过滤空会话](#过滤空会话)
  - [监听未读数变化](#监听未读数变化)
  - [默认会话操作](#默认会话操作)
  - [图标说明](#图标说明)

使用示例如下：

```typescript
import { ConversationList } from 'react-native-chat-uikit';

function ConversationListScreen() {
  return (
    <ConversationList
      // 控制标题栏显示
      navigationBarVisible={true}
      // 控制搜索样式显示
      searchStyleVisible={true}
      // 设置容器样式
      containerStyle={{ backgroundColor: '#f5f5f5' }}
      // 点击会话条目
      onClickedItem={(data) => {
        console.log('clicked:', data);
        // 跳转到聊天页面
        navigation.navigate('Chat', { convId: data.convId });
      }}
      // 长按会话条目
      onLongPressedItem={(data) => {
        console.log('long pressed:', data);
      }}
      // 点击搜索
      onClickedSearch={() => {
        // 跳转到搜索页面
        navigation.navigate('SearchConversation');
      }}
      // 点击新会话按钮
      onClickedNewConversation={() => {
        // 跳转到创建新会话页面
        navigation.navigate('NewConversation');
      }}
      // 点击新群组按钮
      onClickedNewGroup={() => {
        // 跳转到创建群组页面
        navigation.navigate('CreateGroup');
      }}
      // 点击新联系人按钮
      onClickedNewContact={() => {
        // 跳转到添加联系人页面
        navigation.navigate('AddContact');
      }}
      // 过滤空会话
      filterEmptyConversation={true}
      // 监听未读总数变化
      onChangeUnreadCount={(count) => {
        console.log('total unread:', count);
      }}
    />
  );
}
```

`ConversationList` 组件基本属性如下表所示：

| 属性                       | 类型                                                   | 描述                                                                                                                             |
| -------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| `navigationBarVisible`     | `boolean`                                              | 是否显示标题栏。<br/> - `true`（默认）：显示。<br/> - `false`：隐藏。<br/> 详见[显示或隐藏标题栏](#显示或隐藏标题栏)。           |
| `customNavigationBar`      | `React.ReactElement`                                   | 自定义标题栏组件，完整替换默认标题栏。<br/> 详见 [设置页面标题栏](chatuikit_custom_titlebar.html)。                              |
| `searchStyleVisible`       | `boolean`                                              | 是否显示搜索样式组件。<br/> - `true`（默认）：显示。<br/> - `false`：隐藏。<br/> 详见[显示或隐藏搜索样式](#显示或隐藏搜索样式)。 |
| `customSearch`             | `React.ReactElement`                                   | 自定义搜索组件，完整替换默认搜索样式。                                                                                           |
| `onClickedSearch`          | `(data?: any) => void`                                 | 点击搜索组件的回调。                                                                                                             |
| `containerStyle`           | `StyleProp<ViewStyle>`                                 | 会话列表容器的样式。                                                                                                             |
| `onClickedItem`            | `(data?: ConversationModel) => boolean \| void`        | 点击会话条目的回调。返回 `true` 可阻止默认行为。                                                                                 |
| `onLongPressedItem`        | `(data?: ConversationModel) => boolean \| void`        | 长按会话条目的回调。返回 `true` 可阻止默认行为。                                                                                 |
| `onClickedNewConversation` | `() => void`                                           | 点击"新会话"按钮的回调，通常需要跳转到新会话页面。                                                                               |
| `onClickedNewGroup`        | `() => void`                                           | 点击"创建群组"按钮的回调，通常需要跳转到创建群组页面。                                                                           |
| `onClickedNewContact`      | `() => void`                                           | 点击"添加联系人"按钮的回调，通常需要跳转到添加联系人页面。                                                                       |
| `filterEmptyConversation`  | `boolean`                                              | 是否过滤空会话（没有消息的会话）。                                                                                               |
| `onChangeUnreadCount`      | `(unreadCount: number) => void`                        | 会话列表总未读数变化时的回调。                                                                                                   |
| `flatListProps`            | `Omit<FlatListProps, 'ref' \| 'data' \| 'renderItem'>` | 传递给内部 FlatList 的其他属性。                                                                                                 |

## 显示或隐藏标题栏

`ConversationList` 组件通过 `navigationBarVisible` 属性控制标题栏的显示。

```typescript
<ConversationList
  navigationBarVisible={true}  // 显示标题栏（默认）
/>

<ConversationList
  navigationBarVisible={false}  // 隐藏标题栏
/>
```

如果需要完全自定义标题栏，可以使用 `customNavigationBar` 属性：

```typescript
<ConversationList
  customNavigationBar={
    <View style={{ height: 44, backgroundColor: 'blue' }}>
      <Text>自定义标题栏</Text>
    </View>
  }
/>
```

详见 [设置页面标题栏](chatuikit_custom_titlebar.html)。

## 显示或隐藏搜索样式

`ConversationList` 组件通过 `searchStyleVisible` 属性控制搜索样式组件的显示。

```typescript
<ConversationList
  searchStyleVisible={true}  // 显示搜索样式（默认）
  onClickedSearch={() => {
    // 跳转到搜索页面
    navigation.navigate('SearchConversation');
  }}
/>

<ConversationList
  searchStyleVisible={false}  // 隐藏搜索样式
/>
```

:::tip
React Native 的 UIKit 没有内置路由跳转功能，点击搜索时需要通过 `onClickedSearch` 回调自行处理页面跳转。
:::

如果需要完全自定义搜索组件，可以使用 `customSearch` 属性：

```typescript
<ConversationList
  customSearch={
    <TouchableOpacity onPress={() => navigation.navigate('Search')}>
      <View style={{ padding: 10 }}>
        <Text>自定义搜索</Text>
      </View>
    </TouchableOpacity>
  }
/>
```

详见 [设置搜索栏](chatuikit_custom_conversation_list_searchbar.html)。

## 设置容器样式

通过 `containerStyle` 属性可以自定义会话列表容器的样式：

```typescript
<ConversationList
  containerStyle={{
    backgroundColor: '#f5f5f5',
    paddingTop: 10,
  }}
/>
```

## 设置点击事件

### 点击会话条目

通过 `onClickedItem` 处理会话条目的点击事件：

```typescript
<ConversationList
  onClickedItem={(data) => {
    console.log('点击会话:', data.convId, data.convName);
    // 跳转到聊天页面
    navigation.navigate('Chat', {
      convId: data.convId,
      convType: data.convType,
    });
  }}
/>
```

### 长按会话条目

通过 `onLongPressedItem` 处理会话条目的长按事件：

```typescript
<ConversationList
  onLongPressedItem={(data) => {
    console.log('长按会话:', data.convId);
    // 默认会弹出操作菜单（置顶、删除、免打扰等）
    // 返回 true 可以阻止默认菜单弹出
  }}
/>
```

:::tip
长按会话条目时，默认会显示操作菜单，包括置顶、删除、免打扰、标记已读等操作。如果在回调中返回 `true`，则会阻止默认菜单弹出，你可以实现自己的菜单逻辑。
:::

## 处理新会话创建

React Native UIKit 没有内置的页面跳转功能，创建新会话、新群组或添加联系人时，需要通过回调函数自行处理页面跳转：

```typescript
<ConversationList
  onClickedNewConversation={() => {
    // 跳转到新会话页面（选择联系人）
    navigation.navigate('NewConversation');
  }}
  onClickedNewGroup={() => {
    // 跳转到创建群组页面
    navigation.navigate('CreateGroup');
  }}
  onClickedNewContact={() => {
    // 跳转到添加联系人页面
    navigation.navigate('AddContact');
  }}
/>
```

这些按钮位于标题栏右侧的"+"菜单中。

## 过滤空会话

通过 `filterEmptyConversation` 属性可以过滤掉没有消息的空会话：

```typescript
<ConversationList
  filterEmptyConversation={true}  // 过滤空会话
/>
```

## 监听未读数变化

通过 `onChangeUnreadCount` 可以监听会话列表中所有会话的未读总数变化：

```typescript
<ConversationList
  onChangeUnreadCount={(unreadCount) => {
    console.log('未读总数:', unreadCount);
    // 可以用于更新应用角标、标题等
    updateBadge(unreadCount);
  }}
/>
```

## 默认会话操作

长按会话条目会显示会话操作菜单，默认包含以下操作：

| 会话操作              | 描述                                                             |
| :-------------------- | :--------------------------------------------------------------- |
| 会话置顶/取消置顶     | 置顶或取消置顶会话，置顶的会话会显示在列表顶部。                 |
| 会话免打扰/取消免打扰 | 设置或取消会话免打扰，免打扰的会话不会显示未读数字，只显示红点。 |
| 会话标记已读          | 将会话标记为已读状态，清除未读数。                               |
| 会话删除              | 删除会话（会同时删除会话中的所有消息）。                         |

这些操作由 UIKit 内部实现，无需额外编码。

## 图标说明

*图标修改参考图标自定义文档。*

会话列表使用以下默认图标：

| 功能           | 图标名称           | 描述                       |
| -------------- | ------------------ | -------------------------- |
| 标题栏右侧按钮 | `plus_in_circle`   | 打开创建菜单（+按钮）      |
| 搜索框图标     | `magnifier`        | 搜索会话                   |

会话列表标题栏扩展菜单使用以下图标：

| 菜单项     | 图标名称           | 描述               |
| ---------- | ------------------ | ------------------ |
| 创建新会话 | `bubble_fill`      | 创建新的单聊会话   |
| 添加好友   | `person_add_fill`  | 添加新的联系人     |
| 创建群组   | `person_double_fill` | 创建新的群组       |
