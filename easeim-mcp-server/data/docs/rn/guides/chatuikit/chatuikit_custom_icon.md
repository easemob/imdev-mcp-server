# 图标自定义

## 替换内置图标

对于已有的内置的图标，只要找到对应图标名字就可以进行替换。

替换聊天消息输入框扩展菜单图标的示例：

```typescript
import { ICON_ASSETS } from "react-native-chat-uikit";

// 替换内置图标之后，UIKIT组件将使用新的图标
ICON_ASSETS["camera_fill"] = (size: string) => {
  if (size === "3x") {
    return require("./icons/camera_fill_3x.png");
  } else if (size === "2x") {
    return require("./icons/camera_fill_2x.png");
  } else {
    return require("./icons/camera_fill.png");  // 1x 或默认尺寸
  }
};
```

## 使用自定义图标

自定义图标可以在 uikit 内部中使用。

添加的自定义图标在扩展栏菜单中使用的示例：

```typescript
import {
  ICON_ASSETS,
  ConversationDetail,
} from 'react-native-chat-uikit';

// 注册自定义图标
ICON_ASSETS['custom_star'] = (size: string) => {
  if (size === '3x') {
    return require('./your_path/custom_star_3x.png');
  } else if (size === '2x') {
    return require('./your_path/custom_star_2x.png');
  } else {
    return require('./your_path/custom_star.png');  // 1x 或默认尺寸
  }
};

// 使用自定义图标
<ConversationDetail
  type="chat"
  convId={convId}
  convType={convType}
  input={{
    props: {
      onInitMenu: (initItems) => {
        // initItems 是默认的菜单项列表
        console.log('默认菜单项:', initItems);

        // 添加自定义菜单项
        const customItem = {
          name: 'custom',        // 菜单项名称
          isHigh: false,         // 是否高亮显示（通常用于警告操作）
          icon: 'custom_star',   // 使用前面注册的自定义图标
          onClicked: () => {
            console.log('点击自定义菜单项');
            // 实现自定义功能
          },
        };

        // 返回新的菜单项列表（包含默认项和自定义项）
        return [...initItems, customItem];
      },
    },
  }}
  onBack={() => navigation.goBack()}
/>
```
