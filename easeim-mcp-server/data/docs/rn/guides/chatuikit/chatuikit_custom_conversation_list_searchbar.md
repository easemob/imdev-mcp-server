# 设置会话搜索

会话列表页面支持按会话名称搜索会话。你可以设置是否显示搜索栏、自定义搜索样式以及处理搜索点击事件。

**注意：** React Native UIKit 没有内置的路由跳转功能，也没有在 UIKit 内部使用第三方库进行页面跳转。因此，搜索功能需要你在应用层处理页面导航。

// TODO：添加会话搜索栏图片

## 会话列表中显示搜索栏

在会话列表组件中，默认显示搜索样式组件。你可以通过 `searchStyleVisible` 属性控制是否显示：

```typescript
import { ConversationList } from 'react-native-chat-uikit';

<ConversationList
  searchStyleVisible={true} // 默认为 true，显示搜索栏
  onClickedSearch={() => {
    // 处理搜索栏点击事件
    // 通常需要跳转到搜索页面
    navigation.navigate('SearchConversation');
  }}
/>
```

## 自定义搜索样式

如果默认的搜索样式不满足需求，可以通过 `customSearch` 属性自定义搜索组件：

```typescript
import { ConversationList } from 'react-native-chat-uikit';
import { Pressable, Text, View } from 'react-native';

<ConversationList
  customSearch={
    <Pressable
      onPress={() => {
        navigation.navigate('SearchConversation');
      }}
    >
      <View style={{ padding: 10, backgroundColor: '#f0f0f0' }}>
        <Text>自定义搜索栏</Text>
      </View>
    </Pressable>
  }
/>
```

## 使用搜索会话组件

UIKit 提供了独立的搜索会话组件 `SearchConversation`，你可以在自己的搜索页面中使用：

```typescript
import { SearchConversation } from 'react-native-chat-uikit';
import type { ConversationModel } from 'react-native-chat-uikit';

function SearchConversationScreen() {
  return (
    <SearchConversation
      onCancel={() => {
        // 取消搜索，返回上一页
        navigation.goBack();
      }}
      onClicked={(data?: ConversationModel) => {
        if (data) {
          // 点击搜索结果，导航到会话详情页
          navigation.navigate('ConversationDetail', {
            convId: data.convId,
            convType: data.convType,
            convName: data.convName,
            convAvatar: data.convAvatar,
          });
        }
      }}
      filterEmptyConversation={true} // 过滤空会话
      containerStyle={{ flex: 1 }} // 自定义容器样式
    />
  );
}
```

### SearchConversation 组件属性

| 属性 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `onCancel` | `() => void` | 是 | 点击取消按钮的回调 |
| `onClicked` | `(data?: ConversationModel) => void` | 否 | 点击搜索结果的回调 |
| `containerStyle` | `StyleProp<ViewStyle>` | 否 | 容器样式 |
| `filterEmptyConversation` | `boolean` | 否 | 是否过滤空会话（没有消息的会话） |

## 完整使用示例

以下是一个完整的使用示例，展示了如何在会话列表页面集成搜索功能：

**会话列表页面（HomeScreen.tsx）：**

```typescript
import React from 'react';
import { ConversationList } from 'react-native-chat-uikit';

export function HomeScreen({ navigation }) {
  return (
    <ConversationList
      searchStyleVisible={true}
      onClickedSearch={() => {
        // 点击搜索栏，跳转到搜索页面
        navigation.navigate('SearchConversation');
      }}
      onClickedItem={(data) => {
        // 点击会话列表项，跳转到会话详情页
        navigation.navigate('ConversationDetail', {
          convId: data.convId,
          convType: data.convType,
          convName: data.convName,
          convAvatar: data.convAvatar,
        });
      }}
    />
  );
}
```

**搜索页面（SearchConversationScreen.tsx）：**

```typescript
import React from 'react';
import { SafeAreaView } from 'react-native';
import { SearchConversation } from 'react-native-chat-uikit';

export function SearchConversationScreen({ navigation }) {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <SearchConversation
        onCancel={() => {
          navigation.goBack();
        }}
        onClicked={(data) => {
          if (data) {
            // 返回上一页
            navigation.pop();
            // 导航到会话详情页
            navigation.navigate('ConversationDetail', {
              convId: data.convId,
              convType: data.convType,
              convName: data.convName,
              convAvatar: data.convAvatar,
            });
          }
        }}
        filterEmptyConversation={true}
      />
    </SafeAreaView>
  );
}
```

## 搜索组件的通用性

`SearchConversation` 组件基于通用的 `ListSearch` 组件实现，这意味着搜索组件的设计是通用的。除了搜索会话，UIKit 还提供了其他搜索组件：

- `SearchConversation`：搜索会话
- `SearchContact`：搜索联系人
- `SearchGroup`：搜索群组

这些搜索组件都基于相同的设计模式，可以在不同的场景中使用。
