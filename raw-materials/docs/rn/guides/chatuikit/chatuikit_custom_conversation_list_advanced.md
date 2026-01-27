# 会话列表的高级设置

本文介绍如何通过 `ConversationList` 组件实现会话列表的高级设置，包括自定义排序、自定义菜单项、自定义列表项样式、列表控制器以及页面状态监听等。

## 概述

`ConversationList` 组件支持以下高级自定义设置：

- [自定义会话排序](#自定义会话排序)
- [自定义导航栏菜单项](#自定义导航栏菜单项)
- [自定义底部菜单项](#自定义底部菜单项)
- [自定义列表项样式](#自定义列表项样式)
- [使用控制器操作列表](#使用控制器操作列表)
- [监听页面状态](#监听页面状态)
- [通用属性设置](#通用属性设置)

## 自定义会话排序

默认情况下，会话列表按照最后一条消息的时间戳和是否置顶进行排序。你可以通过 `onSort` 属性自定义排序规则：

```typescript
<ConversationList
  onSort={(prevProps, nextProps) => {
    // 返回 -1, 0, 1 表示排序顺序
    // -1: prevProps 在前
    //  0: 顺序不变
    //  1: nextProps 在前

    // 示例：优先按免打扰状态排序
    if (prevProps.data.doNotDisturb && !nextProps.data.doNotDisturb) {
      return 1;  // 免打扰的会话排在后面
    }
    if (!prevProps.data.doNotDisturb && nextProps.data.doNotDisturb) {
      return -1;
    }

    // 其次按时间排序
    const prevTime = prevProps.data.lastMessage?.localTime || 0;
    const nextTime = nextProps.data.lastMessage?.localTime || 0;
    return nextTime - prevTime;
  }}
/>
```

:::tip
自定义排序会覆盖默认的排序逻辑。如果你需要保留置顶功能，请在自定义排序中优先处理 `isPinned` 属性。
:::

## 自定义导航栏菜单项

标题栏右侧的"+"按钮会弹出菜单，默认包含"新会话"、"创建群组"、"添加联系人"等选项。你可以通过 `onInitNavigationBarMenu` 自定义菜单项：

```typescript
<ConversationList
  onInitNavigationBarMenu={(initItems) => {
    // initItems 是默认的菜单项数组
    // 可以添加、删除或修改菜单项

    // 示例：添加一个自定义菜单项
    return [
      ...initItems,
      {
        name: 'custom_scan',
        isHigh: false,
        icon: 'qrcode_scan',
        onClicked: () => {
          console.log('扫一扫');
          // 跳转到扫码页面
        },
      },
    ];
  }}
/>
```

`InitMenuItemsType` 类型定义：

```typescript
type InitMenuItemsType = {
  name: string; // 菜单项唯一标识
  isHigh: boolean; // 是否高亮显示
  icon: string; // 图标名称
  onClicked: () => void; // 点击回调
};
```

### 示例：移除某个默认菜单项

```typescript
<ConversationList
  onInitNavigationBarMenu={(initItems) => {
    // 移除"添加联系人"菜单项
    return initItems.filter(item => item.name !== 'new_contact');
  }}
/>
```

## 自定义底部菜单项

长按会话条目时会弹出底部菜单，默认包含"置顶"、"免打扰"、"标记已读"、"删除"等操作。你可以通过 `onInitBottomMenu` 自定义菜单项：

```typescript
<ConversationList
  onInitBottomMenu={(initItems) => {
    // initItems 是默认的菜单项数组

    // 示例：添加一个"分享"菜单项
    return [
      ...initItems,
      {
        name: 'share',
        isHigh: false,
        icon: 'share',
        onClicked: () => {
          console.log('分享会话');
        },
      },
    ];
  }}
/>
```

### 示例：修改删除按钮样式

```typescript
<ConversationList
  onInitBottomMenu={(initItems) => {
    return initItems.map(item => {
      if (item.name === 'delete') {
        // 将删除按钮设置为高亮（红色）
        return { ...item, isHigh: true };
      }
      return item;
    });
  }}
/>
```

## 自定义列表项样式

如果默认的会话列表项样式不满足需求，可以通过 `ListItemRender` 属性完全自定义列表项组件：

```typescript
import { ConversationListItemProps } from 'react-native-chat-uikit';

// 自定义列表项组件
function CustomConversationItem(props: ConversationListItemProps) {
  const { data, onClicked, onLongPressed } = props;

  return (
    <TouchableOpacity
      onPress={() => onClicked?.(data)}
      onLongPress={() => onLongPressed?.(data)}
    >
      <View style={{ padding: 16, flexDirection: 'row' }}>
        {/* 自定义布局 */}
        <Image source={{ uri: data.convAvatar }} style={{ width: 40, height: 40 }} />
        <View style={{ marginLeft: 12 }}>
          <Text style={{ fontSize: 16, fontWeight: 'bold' }}>{data.convName}</Text>
          <Text style={{ fontSize: 14, color: '#666' }}>
            {data.lastMessage?.content || '暂无消息'}
          </Text>
        </View>
        {data.unreadMessageCount > 0 && (
          <View style={{ backgroundColor: 'red', borderRadius: 10, padding: 4 }}>
            <Text style={{ color: 'white' }}>{data.unreadMessageCount}</Text>
          </View>
        )}
      </View>
    </TouchableOpacity>
  );
}

// 使用自定义列表项
<ConversationList
  ListItemRender={CustomConversationItem}
/>
```

:::tip
自定义列表项组件需要实现 `ConversationListItemProps` 接口，包括 `data`、`onClicked`、`onLongPressed` 等属性。
:::

## 使用控制器操作列表

通过 `propsRef` 可以获取会话列表的控制器，用于在外部操作列表数据：

```typescript
import { useRef } from 'react';
import { ConversationListRef } from 'react-native-chat-uikit';

function ConversationListScreen() {
  const listRef = useRef<ConversationListRef>(null);

  // 添加会话
  const addConversation = (conv: ConversationModel) => {
    listRef.current?.addItem(conv);
  };

  // 更新会话
  const updateConversation = (conv: ConversationModel) => {
    listRef.current?.updateItem(conv);
  };

  // 删除会话
  const deleteConversation = (convId: string) => {
    listRef.current?.removeItem(convId);
  };

  // 刷新列表
  const refreshList = () => {
    listRef.current?.refresh();
  };

  return (
    <View>
      <ConversationList
        propsRef={listRef}
      />
      <Button title="刷新" onPress={refreshList} />
    </View>
  );
}
```

### ConversationListRef 方法说明

| 方法                | 描述                                                                                                                                                                                                                                                                         |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `addItem`           | 添加会话到列表。                                                                                                                                                                                                                                                             |
| `updateItem`        | 更新会话数据。支持更新的字段包括：`unreadMessageCount`、`doNotDisturb`、`ext`。`convName` 和 `convAvatar` 通过 `onUsersProvider` 或 `onGroupsProvider` 更新。`unreadMessageCount` 可以设置为 0，其他值无效。如需自定义，可在 `ext` 字段保存数据并重新定义 `ListItemRender`。 |
| `removeItem`        | 删除会话。                                                                                                                                                                                                                                                                   |
| `refresh`           | 刷新列表数据。                                                                                                                                                                                                                                                               |
| `showStatusActions` | 显示个人状态菜单。                                                                                                                                                                                                                                                           |
| `showMoreActions`   | 显示更多操作菜单。                                                                                                                                                                                                                                                           |

:::warning
如果操作失败，错误会通过 `ErrorServiceListener.onError` 返回。
:::

## 监听页面状态

通过 `onStateChanged` 可以监听会话列表的加载状态变化：

```typescript
<ConversationList
  onStateChanged={(state) => {
    console.log('列表状态:', state);
    // 状态值: 'loading' | 'empty' | 'error' | 'normal'

    switch (state) {
      case 'loading':
        console.log('正在加载...');
        break;
      case 'empty':
        console.log('列表为空');
        break;
      case 'error':
        console.log('加载失败');
        break;
      case 'normal':
        console.log('加载完成');
        break;
    }
  }}
/>
```

状态类型说明：

| 状态      | 描述                       |
| --------- | -------------------------- |
| `loading` | 正在加载会话列表数据       |
| `empty`   | 会话列表为空（没有会话）   |
| `error`   | 加载失败（网络错误等）     |
| `normal`  | 加载完成，正常显示会话列表 |

## 通用属性设置

`ConversationList` 组件继承了一些通用属性类型，这些属性提供了额外的配置能力：

### PropsWithTest

用于测试模式配置：

```typescript
<ConversationList
  testMode="only-ui"  // 仅 UI 模式，不加载真实数据
/>
```

### PropsWithInit

初始化回调：

```typescript
<ConversationList
  onInitialized={(data) => {
    console.log('会话列表初始化完成', data);
  }}
/>
```

### PropsWithBack

返回按钮回调（当标题栏显示返回按钮时）：

```typescript
<ConversationList
  onBack={(data) => {
    console.log('点击返回按钮');
    navigation.goBack();
  }}
/>
```

### PropsWithSearch

搜索相关配置，详见 [基本设置文档](chatuikit_custom_conversation_list_basic.html#显示或隐藏搜索样式)。

### PropsWithNavigationBar

标题栏相关配置，详见 [基本设置文档](chatuikit_custom_conversation_list_basic.html#显示或隐藏标题栏)。

### PropsWithFlatList

传递给内部 FlatList 的属性：

```typescript
<ConversationList
  flatListProps={{
    // 任何 FlatList 支持的属性（除了 ref、data、renderItem）
    showsVerticalScrollIndicator: false,
    bounces: false,
    ItemSeparatorComponent: () => <View style={{ height: 1, backgroundColor: '#eee' }} />,
    ListHeaderComponent: <Text>会话列表头部</Text>,
    ListFooterComponent: <Text>会话列表底部</Text>,
  }}
/>
```

### PropsWithMenu

菜单相关配置（已在[自定义底部菜单项](#自定义底部菜单项)中介绍）。

## 完整示例

以下是一个包含多种高级设置的完整示例：

```typescript
import React, { useRef } from 'react';
import { View, Button } from 'react-native';
import { ConversationList, ConversationListRef } from 'react-native-chat-uikit';

function AdvancedConversationListScreen({ navigation }) {
  const listRef = useRef<ConversationListRef>(null);

  return (
    <View style={{ flex: 1 }}>
      <ConversationList
        // 基本设置
        navigationBarVisible={true}
        searchStyleVisible={true}
        filterEmptyConversation={true}

        // 自定义排序
        onSort={(prev, next) => {
          // 置顶优先
          if (prev.data.isPinned && !next.data.isPinned) return -1;
          if (!prev.data.isPinned && next.data.isPinned) return 1;
          // 然后按时间排序
          const prevTime = prev.data.lastMessage?.localTime || 0;
          const nextTime = next.data.lastMessage?.localTime || 0;
          return nextTime - prevTime;
        }}

        // 自定义导航栏菜单
        onInitNavigationBarMenu={(items) => [
          ...items,
          {
            name: 'custom_action',
            isHigh: false,
            icon: 'setting',
            onClicked: () => navigation.navigate('Settings'),
          },
        ]}

        // 自定义底部菜单
        onInitBottomMenu={(items) => [
          ...items.map(item =>
            item.name === 'delete' ? { ...item, isHigh: true } : item
          ),
        ]}

        // 控制器
        propsRef={listRef}

        // 状态监听
        onStateChanged={(state) => {
          console.log('State:', state);
        }}

        // 事件处理
        onClickedItem={(data) => {
          navigation.navigate('Chat', { convId: data.convId });
        }}

        onClickedSearch={() => {
          navigation.navigate('SearchConversation');
        }}

        // FlatList 属性
        flatListProps={{
          showsVerticalScrollIndicator: false,
        }}
      />

      <Button
        title="刷新列表"
        onPress={() => listRef.current?.refresh()}
      />
    </View>
  );
}
```

## 高级属性总览

以下是会话列表高级属性的完整列表：

| 属性                      | 类型                                                   | 描述                                 |
| ------------------------- | ------------------------------------------------------ | ------------------------------------ |
| `onSort`                  | `(prev, next) => number`                               | 自定义会话排序规则。                 |
| `onInitNavigationBarMenu` | `(items) => InitMenuItemsType[]`                       | 自定义导航栏菜单项。                 |
| `onInitBottomMenu`        | `(items) => InitMenuItemsType[]`                       | 自定义底部菜单项（长按会话时显示）。 |
| `ListItemRender`          | `ConversationListItemComponentType`                    | 自定义列表项组件。                   |
| `propsRef`                | `React.MutableRefObject<ConversationListRef>`          | 列表控制器引用。                     |
| `onStateChanged`          | `(state: ListStateType) => void`                       | 列表状态变化回调。                   |
| `testMode`                | `'only-ui' \| undefined`                               | 测试模式。                           |
| `onInitialized`           | `(data?: any) => void`                                 | 初始化完成回调。                     |
| `onBack`                  | `(data?: any) => void`                                 | 返回按钮点击回调。                   |
| `flatListProps`           | `Omit<FlatListProps, 'ref' \| 'data' \| 'renderItem'>` | FlatList 组件的其他属性。            |
