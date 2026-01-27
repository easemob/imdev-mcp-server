# 主题和调色板

## 概述

UIKit 提供了强大的主题定制能力，让您可以根据品牌需求自定义界面外观。主题系统主要包括三个核心部分：

- **调色板（Palette）**：基础的颜色和样式系统，包括颜色、字体、渐变、圆角等
- **主题（Theme）**：基于调色板构建的高级主题配置，提供明暗两种风格
- **字体（FontFamily）**：全局字体配置，支持普通字体、Emoji 字体和标题字体

这些配置都在 `Container` 组件初始化时进行设置，影响整个应用的界面风格。

## 调色板（Palette）

### 什么是调色板

调色板是主题系统的基础，它定义了应用中使用的所有颜色、字体样式、渐变效果和圆角样式。调色板采用 HSL 色彩模型，可以精确控制色相、饱和度和亮度。

### 使用默认调色板

最简单的方式是使用内置的预设调色板：

```tsx
import { usePresetPalette } from "react-native-chat-uikit";

export function App() {
  const palette = usePresetPalette();

  return (
    <UIKitContainer palette={palette} options={getOptions()}>
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

### 创建自定义调色板

您可以通过 `useCreatePalette` 创建自定义调色板，调整主色、辅助色、错误色等：

```tsx
import { useCreatePalette } from "react-native-chat-uikit";

export function App() {
  // 定义自定义颜色参数（使用 HSL 色相值 0-360）
  const customParams = {
    colors: {
      primary: 203, // 主色（蓝色系）
      secondary: 155, // 辅助色（绿色系）
      error: 350, // 错误色（红色系）
      neutral: 203, // 中性色
      neutralSpecial: 220, // 特殊中性色
    },
  };

  const { createPalette } = useCreatePalette(customParams);
  const customPalette = createPalette();

  return (
    <UIKitContainer palette={customPalette} options={getOptions()}>
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

### 调整调色板的颜色

创建调色板后，您还可以直接修改具体的颜色值：

```tsx
const customPalette = createPalette();

// 修改主色
customPalette.colors.primary = generatePrimaryColor(180); // 改为青色系

// 修改特定亮度的颜色
// 每个颜色都有 0-100 的亮度级别，如 primary.0, primary.1, ..., primary.100
customPalette.colors.primary[6] = "hsla(203, 100%, 60%, 1)";
```

### 调整字体样式

调色板中也包含字体样式配置，您可以自定义字体大小、行高等：

```tsx
// 修改大标题字体
customPalette.fonts.headline = {
  large: {
    fontSize: 24, // 原来是 23
    fontWeight: "600",
    lineHeight: 32,
    ...customPalette.fonts.headline.large,
  },
  ...customPalette.fonts.headline,
};

// 修改正文字体
customPalette.fonts.body = {
  large: {
    fontSize: 18,
    fontWeight: "400",
    lineHeight: 24,
    ...customPalette.fonts.body.large,
  },
  ...customPalette.fonts.body,
};
```

调色板支持的字体类型包括：

- `headline`：大标题
- `title`：标题
- `label`：标签
- `body`：正文

每种类型都有 `large`、`medium`、`small` 和 `extraSmall` 四种尺寸。

## 主题（Theme）

### 什么是主题

主题是基于调色板构建的高级配置，它组合调色板中的颜色和样式，形成统一的界面风格。UIKit 内置了明暗两种主题。

### 使用默认主题

```tsx
import { useDarkTheme, useLightTheme } from "react-native-chat-uikit";

export function App() {
  const palette = usePresetPalette();
  const darkTheme = useDarkTheme(palette); // 暗色主题
  const lightTheme = useLightTheme(palette); // 亮色主题

  const [isDark, setIsDark] = React.useState(false);

  return (
    <UIKitContainer
      palette={palette}
      theme={isDark ? darkTheme : lightTheme}
      options={getOptions()}
    >
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

### 创建自定义主题

您可以使用 `useCreateTheme` 创建完全自定义的主题：

```tsx
import { useCreateTheme } from "react-native-chat-uikit";

export function App() {
  const palette = usePresetPalette();

  const params = React.useMemo(() => {
    return {
      palette,
      themeType: "light" as ThemeType,
      releaseArea: "global" as ReleaseArea,
    };
  }, [palette]);

  const { createTheme } = useCreateTheme(params);
  const customTheme = createTheme();

  return (
    <UIKitContainer
      palette={palette}
      theme={customTheme}
      options={getOptions()}
    >
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

### 自定义阴影效果

主题对象中包含阴影样式，您可以自定义按钮、卡片等组件的阴影效果：

```tsx
import type { Shadow } from "react-native-chat-uikit";

const customTheme = createTheme();

// 修改小尺寸阴影
customTheme.shadow.style.small = [
  {
    shadowColor: "#000000",
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  } as Shadow,
];

// 修改中等尺寸阴影
customTheme.shadow.style.medium = [
  {
    shadowColor: "#000000",
    shadowOffset: {
      width: 0,
      height: 4,
    },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 4,
  } as Shadow,
];
```

### 自定义圆角样式

主题中的圆角配置会影响头像、输入框、对话气泡等组件：

```tsx
customTheme.cornerRadius = {
  avatar: "large", // 头像圆角：small | medium | large | extraLarge | extraSmall
  alert: "medium", // 提示框圆角
  input: "extraLarge", // 输入框圆角
  bubble: ["extraSmall", "medium", "extraLarge"], // 消息气泡支持多种圆角
};
```

## 字体（FontFamily）

### 字体配置选项

UIKit 提供三种字体配置，分别应用于不同的界面元素：

1. **fontFamily**：应用于大部分 UI 文本
2. **emojiFontFamily**：专门用于 Emoji 表情的显示
3. **headerFontFamily**：应用于导航栏和标题

### 使用自定义字体

```tsx
export function App() {
  return (
    <UIKitContainer
      palette={palette}
      theme={theme}
      fontFamily="PingFang SC" // 普通文本字体
      emojiFontFamily="Apple Color Emoji" // Emoji 字体
      headerFontFamily="PingFang SC Medium" // 标题字体
      options={getOptions()}
    >
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

### 使用自定义字体文件

如果需要使用自定义字体文件，需要先加载字体资源：

```tsx
import * as Font from "expo-font";

export function App() {
  const [fontsLoaded] = Font.useFonts({
    "CustomFont-Regular": require("./assets/fonts/CustomFont-Regular.ttf"),
    "CustomFont-Bold": require("./assets/fonts/CustomFont-Bold.ttf"),
  });

  if (!fontsLoaded) {
    return null; // 或显示加载界面
  }

  return (
    <UIKitContainer
      palette={palette}
      theme={theme}
      fontFamily="CustomFont-Regular"
      headerFontFamily="CustomFont-Bold"
      options={getOptions()}
    >
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

## 发布区域（Release Area）

UIKit 支持根据不同发布区域自动调整界面风格：

- **china**：中国区风格，使用较小的圆角
- **global**：国际区风格，使用较大的圆角

```tsx
export function App() {
  return (
    <UIKitContainer
      palette={palette}
      theme={theme}
      releaseArea="global" // 或 "china"
      options={getOptions()}
    >
      {/* 子组件 */}
    </UIKitContainer>
  );
}
```

该配置会影响：

- 头像的圆角大小
- 输入框的圆角大小
- 提示框的圆角大小
- 消息气泡的圆角选项

## 完整示例

以下是一个包含自定义调色板、主题和字体的完整示例：

```tsx
import * as React from "react";
import {
  UIKitContainer,
  usePresetPalette,
  useCreatePalette,
  useLightTheme,
  useDarkTheme,
  generatePrimaryColor,
} from "react-native-chat-uikit";

export function App() {
  // 创建自定义调色板
  const customParams = {
    colors: {
      primary: 210, // 蓝色系
      secondary: 160, // 绿色系
      error: 5, // 红色系
      neutral: 210,
      neutralSpecial: 220,
    },
  };

  const { createPalette } = useCreatePalette(customParams);
  const palette = createPalette();

  // 自定义字体大小
  palette.fonts.headline.large = {
    fontSize: 24,
    fontWeight: "600",
    lineHeight: 32,
    ...palette.fonts.headline.large,
  };

  // 创建主题
  const darkTheme = useDarkTheme(palette);
  const lightTheme = useLightTheme(palette);

  // 自定义阴影
  darkTheme.shadow.style.medium = [
    {
      shadowColor: "#000000",
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.2,
      shadowRadius: 8,
      elevation: 4,
    },
  ];

  const [isDark, setIsDark] = React.useState(false);

  return (
    <UIKitContainer
      palette={palette}
      theme={isDark ? darkTheme : lightTheme}
      fontFamily="PingFang SC"
      headerFontFamily="PingFang SC Medium"
      releaseArea="global"
      options={getOptions()}
    >
      {/* 您的应用内容 */}
    </UIKitContainer>
  );
}
```

## 最佳实践

### 1. 保持颜色系统一致

使用调色板时，建议只修改色相值（0-360），让系统自动生成不同亮度的颜色变体，这样可以保持颜色系统的一致性。

```tsx
// ✅ 推荐：只修改色相
const customParams = {
  colors: {
    primary: 210, // 系统会自动生成 primary.0 到 primary.100
  },
};

// ❌ 不推荐：手动设置每个亮度级别
customPalette.colors.primary[0] = "#000000";
customPalette.colors.primary[1] = "#1a1a1a";
// ... 太繁琐且容易不一致
```

### 2. 先调色板后主题

建议的配置顺序：

1. 首先创建或获取调色板
2. 根据需要修改调色板的颜色和字体
3. 基于调色板创建主题
4. 最后修改主题的阴影和圆角

### 3. 使用 React.useMemo 优化性能

主题和调色板的创建相对耗时，建议使用 `useMemo` 缓存：

```tsx
const palette = React.useMemo(() => {
  const { createPalette } = useCreatePalette(customParams);
  return createPalette();
}, [customParams]);

const theme = React.useMemo(() => {
  return useLightTheme(palette);
}, [palette]);
```
