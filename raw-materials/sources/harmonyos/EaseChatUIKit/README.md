# 环信 HarmonyOS ChatUIKit

## 前提条件
- DevEco Studio NEXT Release（5.0.3.900）及以上；
- HarmonyOS SDK API 12 及以上；
- HarmonyOS NEXT.0.0.71 或以上版本的模拟器或者真机；
- 有效的环信即时通讯 IM 开发者账号和 App key，请参阅 [环信即时通讯云控制台](https://console.easemob.com/user/login)。

## 使用 ChatUIKit

### 集成 ChatUIKit SDK
```shell
ohpm install @easemob/chatuikit
```

### 添加项目权限
```json
{
  "name": "ohos.permission.MICROPHONE",
  "reason": "$string:record_permission_reason",
  "usedScene": {
    "abilities": [
      "EntryAbility" // 如果是多Ability应用，则需要写需要用到的Ability.
    ],
    "when": "always"
  }
}
```
> 相机、文件管理、联系人等系统应用提供了系统Picker组件，支持开发者无需申请权限。

### 初始化
```typescript
let options = new ChatOptions({
  appKey: '您的应用APPKEY'
});
let client = ChatClient.getInstance();
// 先初始化IM SDK
client.init(context, options);
// 将初始化IM SDK对象传入到ChatUIKit中，并进行ChatUIKit的初始化
ChatUIKitClient.init(client);
```

### 登录

```typescript
ChatUIKitClient.login(this.userId, this.userToken).then
(()=> {
  // 登录成功的逻辑
}).catch((err: ChatError) => {
  // 登录失败的逻辑
})
```

请勿使用 IM SDK 提供的 `login` 方法进行登录，建议使用 ChatUIKit 的 `login` 方法，该方法包含针对 ChatUIKit 的处理逻辑。

### 搭建 UI 界面

#### 组件介绍
ChatUIKit 提供了多个集成化的Page页面，主要页面如下表：

| 页面名称           | 路由地址                     |
|------------------|-----------------------------|
| 会话列表页面     | ConversationListPage          |
| 聊天页面         | ChatPage                       |
| 联系人列表页面     | ContactListPage              |
| 创建群组页面      | CreateGroupPage                  |


开发者可以通过组件导航 (Navigation)进行跳转。比如登录成功后，要跳转到会话列表页面：
```typescript
this.pathStack.pushPathByName("ConversationListPage", null, false);
```

#### 使用状态管理V2版本
在鸿蒙 ChatUIKit 中主要使用状态管理V2版本，如果开发者项目中主要使用状态管理V1版本，使用时可参考[自定义组件混用场景指导](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-custom-component-mixed-scenarios)。

## 更多
- [鸿蒙IM SDK用户指南](https://doc.easemob.com/document/harmonyos/integration.html)；
