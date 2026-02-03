[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatClient

# Class: ChatClient

Defined in: ChatClient.ts:77

The chat client class, which is the entry of the chat SDK. It defines how to log in to and log out of the chat app and how to manage the connection between the SDK and the chat server.

## Extends

- `BaseManager`

## Properties

### \_eventEmitter?

> `protected` `optional` **\_eventEmitter**: `NativeEventEmitter`

Defined in: \_\_internal\_\_/Base.ts:19

#### Inherited from

`BaseManager._eventEmitter`

***

### eventType

> `static` **eventType**: `number` = `2`

Defined in: ChatClient.ts:78

***

### TAG

> `protected` `static` **TAG**: `string` = `'ChatClient'`

Defined in: ChatClient.ts:79

#### Overrides

`BaseManager.TAG`

## Accessors

### chatManager

#### Get Signature

> **get** **chatManager**(): [`ChatManager`](ChatManager.md)

Defined in: ChatClient.ts:1134

Gets the chat manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatManager`](ChatManager.md)

The chat manager class.

***

### contactManager

#### Get Signature

> **get** **contactManager**(): [`ChatContactManager`](ChatContactManager.md)

Defined in: ChatClient.ts:1156

Gets the contact manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatContactManager`](ChatContactManager.md)

The contact manager class.

***

### currentUserName

#### Get Signature

> **get** **currentUserName**(): `string`

Defined in: ChatClient.ts:451

Gets the current logged-in user ID.

**Note**

The user ID for successful login is valid.

The user ID is obtained from the memory and updated in the case of login, logout, and reconnection upon disconnection. You can call [getCurrentUsername](#getcurrentusername) to get the latest data from the server.

##### Returns

`string`

The current logged-in user ID.

***

### groupManager

#### Get Signature

> **get** **groupManager**(): [`ChatGroupManager`](ChatGroupManager.md)

Defined in: ChatClient.ts:1145

Gets the chat group manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatGroupManager`](ChatGroupManager.md)

The chat group manager class.

***

### options

#### Get Signature

> **get** **options**(): [`ChatOptions`](ChatOptions.md) \| `undefined`

Defined in: ChatClient.ts:435

Gets the SDK configurations.

Ensure that you set the SDK options during initialization. See [ChatOptions](ChatOptions.md).

##### Returns

[`ChatOptions`](ChatOptions.md) \| `undefined`

The SDK configurations.

***

### presenceManager

#### Get Signature

> **get** **presenceManager**(): [`ChatPresenceManager`](ChatPresenceManager.md)

Defined in: ChatClient.ts:1200

Gets the presence manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatPresenceManager`](ChatPresenceManager.md)

The presence manager class.

***

### pushManager

#### Get Signature

> **get** **pushManager**(): [`ChatPushManager`](ChatPushManager.md)

Defined in: ChatClient.ts:1167

Gets the push manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatPushManager`](ChatPushManager.md)

The push manager class.

***

### roomManager

#### Get Signature

> **get** **roomManager**(): [`ChatRoomManager`](ChatRoomManager.md)

Defined in: ChatClient.ts:1189

Gets the chat room manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatRoomManager`](ChatRoomManager.md)

The chat room manager class.

***

### userManager

#### Get Signature

> **get** **userManager**(): [`ChatUserInfoManager`](ChatUserInfoManager.md)

Defined in: ChatClient.ts:1178

Gets the user information manager class.

This method can be called only after the chat client is initialized.

##### Returns

[`ChatUserInfoManager`](ChatUserInfoManager.md)

The user information manager class.

***

### version

#### Get Signature

> **get** **version**(): `string`

Defined in: ChatClient.ts:423

##### Returns

`string`

## Methods

### addConnectionListener()

> **addConnectionListener**(`listener`): `void`

Defined in: ChatClient.ts:1020

Adds the connection status listener.

#### Parameters

##### listener

[`ChatConnectEventListener`](../interfaces/ChatConnectEventListener.md)

The connection status listener to add.

#### Returns

`void`

***

### addCustomListener()

> **addCustomListener**(`listener`): `void`

Defined in: ChatClient.ts:1078

Adds a custom listener to receive data that the iOS or Android devices send to the React Native layer.

#### Parameters

##### listener

[`ChatCustomEventListener`](../interfaces/ChatCustomEventListener.md)

The custom listener to add.

#### Returns

`void`

***

### addExceptListener()

> **addExceptListener**(`listener`): `void`

Defined in: ChatClient.ts:1106

Add error listener.

Monitor SDK internal errors.

#### Parameters

##### listener

[`ChatExceptionEventListener`](../interfaces/ChatExceptionEventListener.md)

#### Returns

`void`

***

### addMultiDeviceListener()

> **addMultiDeviceListener**(`listener`): `void`

Defined in: ChatClient.ts:1048

Adds the multi-device listener.

#### Parameters

##### listener

[`ChatMultiDeviceEventListener`](../interfaces/ChatMultiDeviceEventListener.md)

The multi-device listener to add.

#### Returns

`void`

***

### changeAppId()

> **changeAppId**(`newAppId`): `Promise`\<`void`\>

Defined in: ChatClient.ts:799

Updates the App id, which is the unique identifier used to access the chat service.

**Note**

- As this id controls access to the chat service for your app, you can only update the id when the current user is logged out.

- Updating the App id means to switch to a new App id.

- You can retrieve the new App id from the Console.

- You can also set an App id by using the [ChatOptions.appId](ChatOptions.md#appid) method when logged out.

#### Parameters

##### newAppId

`string`

The new App id. Ensure that you set this parameter.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeAppKey()

> **changeAppKey**(`newAppKey`): `Promise`\<`void`\>

Defined in: ChatClient.ts:769

Updates the App Key, which is the unique identifier used to access the chat service.

**Note**

- As this key controls access to the chat service for your app, you can only update the key when the current user is logged out.

- Updating the App Key means to switch to a new App Key.

- You can retrieve the new App Key from the Console.

- You can also set an App Key by using the [ChatOptions.appKey](ChatOptions.md#appkey) method when logged out.

#### Parameters

##### newAppKey

`string`

The new App Key. Ensure that you set this parameter.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### compressLogs()

> **compressLogs**(): `Promise`\<`string` \| `undefined`\>

Defined in: ChatClient.ts:821

Compresses the debug log file into a gzip archive.

We strongly recommend that you delete this debug archive once it is no longer used.

#### Returns

`Promise`\<`string` \| `undefined`\>

The path of the compressed gzip file.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### createAccount()

> **createAccount**(`userId`, `password`): `Promise`\<`void`\>

Defined in: ChatClient.ts:591

Creates a new user (open registration).

**Note**

There are two registration modes:

- Open registration: This mode is for testing use, but not recommended in a formal environment;
  If a call failure occurs, you can contact our business manager.

- Authorized registration: You can create a new user through a REST API, and then save it to your server or return it to the client.

#### Parameters

##### userId

`string`

The user ID.
                Ensure that you set this parameter. The user ID can be a maximum of 64 characters of the following types:
                - 26 English letters (a-z)
                - 10 numbers (0-9),
                - "_", "-", "."
                The user ID is case-insensitive, so Aa and aa are the same user ID.
                The email address or the UUID of the user cannot be used as the user ID.
                You can also set this parameter with the regular expression ^[a-zA-Z0-9_-]+$.

##### password

`string`

The password. Ensure that you set this parameter. The password can contain a maximum of 64 characters.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getAccessToken()

> **getAccessToken**(): `Promise`\<`string`\>

Defined in: ChatClient.ts:559

Gets the token for login.

#### Returns

`Promise`\<`string`\>

The token for login.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getCurrentUsername()

> **getCurrentUsername**(): `Promise`\<`string`\>

Defined in: ChatClient.ts:515

Gets the current logged-in user ID from the server.

**Note**

To get the current logged-in user ID from the memory, see [currentUserName](#currentusername).

#### Returns

`Promise`\<`string`\>

The logged-in user ID.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getEventEmitter()

> **getEventEmitter**(): `NativeEventEmitter`

Defined in: ChatClient.ts:102

#### Returns

`NativeEventEmitter`

***

### getLoggedInDevicesFromServer()

> **getLoggedInDevicesFromServer**(`userId`, `pwdOrToken`, `isPassword?`): `Promise`\<[`ChatDeviceInfo`](ChatDeviceInfo.md)[]\>

Defined in: ChatClient.ts:838

Gets the list of online devices to which you have logged in with a specified account.

#### Parameters

##### userId

`string`

The user ID.

##### pwdOrToken

`string`

The password or token.

##### isPassword?

`boolean`

If true, use password, otherwise use token. Default is true. See [pwdOrToken](#getloggedindevicesfromserver-1)

#### Returns

`Promise`\<[`ChatDeviceInfo`](ChatDeviceInfo.md)[]\>

The list of the online logged-in devices.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getRTCTokenInfoWithChannelName()

> **getRTCTokenInfoWithChannelName**(`channelName`): `Promise`\<[`ChatRTCTokenInfo`](ChatRTCTokenInfo.md)\>

Defined in: ChatClient.ts:973

Gets the Agora RTC token, token expiration time, and RTC UID matching the Agora Chat user ID according to the channel name (channelName).

You must enable the Agora RTC feature before calling this API.

If the channel name is set to null, an RTC token valid for all channels will be generated.

This is an asynchronous method.

#### Parameters

##### channelName

`string`

The Agora RTC channel name.

#### Returns

`Promise`\<[`ChatRTCTokenInfo`](ChatRTCTokenInfo.md)\>

The RTC token information. See [ChatRTCTokenInfo](ChatRTCTokenInfo.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getUserIdsWithRTCUids()

> **getUserIdsWithRTCUids**(`ids`): `Promise`\<`Map`\<`number`, `string`\>\>

Defined in: ChatClient.ts:998

Gets the Agora Chat user IDs matching the Agora RTC UIDs.

#### Parameters

##### ids

`number`[]

The Agora RTC UID list.

#### Returns

`Promise`\<`Map`\<`number`, `string`\>\>

The map of Agora RTC UIDs and Agora Chat user IDs.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### init()

> **init**(`options`): `Promise`\<`void`\>

Defined in: ChatClient.ts:468

Initializes the SDK.

**Note**

- Make sure to initialize the SDK in the main thread.
- This method must be called before any other methods are called.

#### Parameters

##### options

[`ChatOptions`](ChatOptions.md)

The options for SDK initialization. Ensure that you set the options. See [ChatOptions](ChatOptions.md).

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### isConnected()

> **isConnected**(): `Promise`\<`boolean`\>

Defined in: ChatClient.ts:496

Checks whether the SDK is connected to the chat server.

#### Returns

`Promise`\<`boolean`\>

Whether the SDK is connected to the chat server.
        - `true`: Yes.
        - `false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### isLoginBefore()

> **isLoginBefore**(): `Promise`\<`boolean`\>

Defined in: ChatClient.ts:544

Checks whether the current user is logged in to the app.

**Note**

This method needs to be called after initialization and before login.

#### Returns

`Promise`\<`boolean`\>

Whether the user is logged in to the app:
         - `true`: The user is logged in to the app. In automatic login mode, the SDK returns `true` before successful login and `false` otherwise.
         - `false`: The user is not logged in to the app. In non-automatic login mode, the SDK returns `false`.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### kickAllDevices()

> **kickAllDevices**(`userId`, `pwdOrToken`, `isPassword?`): `Promise`\<`void`\>

Defined in: ChatClient.ts:909

Logs out from a specified account on all devices.

#### Parameters

##### userId

`string`

The user ID.

##### pwdOrToken

`string`

The password or token.

##### isPassword?

`boolean`

Whether the password or user token is used. See [pwdOrToken](#kickalldevices-1).
- （Default）`true`：The password is used.
- `false`: The user token is used.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### kickDevice()

> **kickDevice**(`userId`, `pwdOrToken`, `resource`, `isPassword?`): `Promise`\<`void`\>

Defined in: ChatClient.ts:880

Logs out from a specified account on a device.

For how to get the device ID, see [ChatDeviceInfo.resource](ChatDeviceInfo.md#resource).

#### Parameters

##### userId

`string`

The user ID.

##### pwdOrToken

`string`

The password or token.

##### resource

`string`

The device ID. See [ChatDeviceInfo.resource](ChatDeviceInfo.md#resource).

##### isPassword?

`boolean`

Whether the password or user token is used. See [pwdOrToken](#kickdevice-1).
- （Default）`true`：The password is used.
- `false`: The user token is used.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~login()~~

> **login**(`userId`, `pwdOrToken`, `isPassword`): `Promise`\<`void`\>

Defined in: ChatClient.ts:623

Logs in to the chat server with a password or an Easemob token. An exception message is thrown if the login fails.

**Note**

If you use an Easemob token to log in to the server, you can get the token in either of the following ways:
- Through an SDK API. See [createAccount](#createaccount) or [getAccessToken](#getaccesstoken).
- Through the console.

The token expiration reminder is returned by the two callback methods: [ChatConnectEventListener.onTokenWillExpire](../interfaces/ChatConnectEventListener.md#ontokenwillexpire) and [ChatConnectEventListener.onTokenDidExpire](../interfaces/ChatConnectEventListener.md#ontokendidexpire).

#### Parameters

##### userId

`string`

The user ID. See [createAccount](#createaccount).

##### pwdOrToken

`string`

The password or token. See [createAccount](#createaccount) or [getAccessToken](#getaccesstoken)

##### isPassword

`boolean` = `true`

Whether to log in with a password or token.
                   - (Default) `true`: A password is used.
                   - `false`: A token is used.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

Please use with [loginWithToken](#loginwithtoken) instead.

***

### ~~loginWithAgoraToken()~~

> **loginWithAgoraToken**(`userId`, `agoraToken`): `Promise`\<`void`\>

Defined in: ChatClient.ts:692

#### Parameters

##### userId

`string`

The user ID.

##### agoraToken

`string`

The Agora token.

#### Returns

`Promise`\<`void`\>

#### Deprecated

2023-11-17 Use [login](#login) instead.

Logs in to the chat server with the user ID and an Agora token. An exception message is thrown if the login fails.

**Note**

The Agora token is different from token login.token provided by Easemob.

This method supports automatic login.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### loginWithToken()

> **loginWithToken**(`userId`, `token`): `Promise`\<`void`\>

Defined in: ChatClient.ts:659

Logs in to the chat server with a token. An exception message is thrown if the login fails.

**Note**

If you use a token to log in to the server, you can get the token in either of the following ways:
- Through the console.

The token expiration reminder is returned by the two callback methods: [ChatConnectEventListener.onTokenWillExpire](../interfaces/ChatConnectEventListener.md#ontokenwillexpire) and [ChatConnectEventListener.onTokenDidExpire](../interfaces/ChatConnectEventListener.md#ontokendidexpire).

#### Parameters

##### userId

`string`

The user ID.

##### token

`string`

The password or token.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### logout()

> **logout**(`unbindDeviceToken`): `Promise`\<`void`\>

Defined in: ChatClient.ts:741

Logs out of the chat app. An exception message is thrown if the logout fails.

#### Parameters

##### unbindDeviceToken

`boolean` = `true`

Whether to unbind the token upon logout. This parameter is available only to mobile platforms.
- (Default) `true`: Yes.
- `false`: No.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllConnectionListener()

> **removeAllConnectionListener**(): `void`

Defined in: ChatClient.ts:1038

Removes all the connection status listeners for the chat server.

#### Returns

`void`

***

### removeAllCustomListener()

> **removeAllCustomListener**(): `void`

Defined in: ChatClient.ts:1096

Removes all the custom listeners.

#### Returns

`void`

***

### removeAllExceptListener()

> **removeAllExceptListener**(): `void`

Defined in: ChatClient.ts:1122

Remove all error listener.

#### Returns

`void`

***

### removeAllMultiDeviceListener()

> **removeAllMultiDeviceListener**(): `void`

Defined in: ChatClient.ts:1068

Removes all the multi-device listeners.

#### Returns

`void`

***

### removeConnectionListener()

> **removeConnectionListener**(`listener`): `void`

Defined in: ChatClient.ts:1030

Removes the connection status listener.

#### Parameters

##### listener

[`ChatConnectEventListener`](../interfaces/ChatConnectEventListener.md)

The connection status listener to remove.

#### Returns

`void`

***

### removeCustomListener()

> **removeCustomListener**(`listener`): `void`

Defined in: ChatClient.ts:1088

Removes a custom listener to stop receiving data that the iOS or Android devices send to the React Native layer.

#### Parameters

##### listener

[`ChatCustomEventListener`](../interfaces/ChatCustomEventListener.md)

The custom listener to remove.

#### Returns

`void`

***

### removeExceptListener()

> **removeExceptListener**(`listener`): `void`

Defined in: ChatClient.ts:1114

Remove error listener.

#### Parameters

##### listener

[`ChatExceptionEventListener`](../interfaces/ChatExceptionEventListener.md)

#### Returns

`void`

***

### removeMultiDeviceListener()

> **removeMultiDeviceListener**(`listener`): `void`

Defined in: ChatClient.ts:1058

Removes the specified multi-device listener.

#### Parameters

##### listener

[`ChatMultiDeviceEventListener`](../interfaces/ChatMultiDeviceEventListener.md)

The multi-device listener to remove.

#### Returns

`void`

***

### renewAgoraToken()

> **renewAgoraToken**(`agoraToken`): `Promise`\<`void`\>

Defined in: ChatClient.ts:722

Renews the Agora token.

**Note**

If you log in with an Agora token and are notified by the callback method [ChatConnectEventListener](../interfaces/ChatConnectEventListener.md) that the token is to expire, you can call this method to update the token to avoid unknown issues caused by an invalid token.

#### Parameters

##### agoraToken

`string`

The new Agora token.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatClient.ts:149

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

#### Overrides

`BaseManager.setNativeListener`

***

### updatePushConfig()

> **updatePushConfig**(`config`): `Promise`\<`void`\>

Defined in: ChatClient.ts:935

Update push configurations.

**Note**
For the iOS platform, you need to pass the device ID during initialization. Otherwise, the push function cannot be used properly. See [ChatClient.init](#init)

#### Parameters

##### config

[`ChatPushConfig`](ChatPushConfig.md)

The push config, See [ChatPushConfig](ChatPushConfig.md)

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### \_callMethod()

> `protected` `static` **\_callMethod**\<`T`\>(`method`, `args?`): `Promise`\<`T`\>

Defined in: \_\_internal\_\_/Native.ts:14

#### Type Parameters

##### T

`T`

#### Parameters

##### method

`string`

##### args?

`Object`

#### Returns

`Promise`\<`T`\>

#### Inherited from

`BaseManager._callMethod`

***

### checkErrorFromResult()

> `protected` `static` **checkErrorFromResult**(`result`): `void`

Defined in: \_\_internal\_\_/Native.ts:9

#### Parameters

##### result

`any`

#### Returns

`void`

#### Inherited from

`BaseManager.checkErrorFromResult`

***

### getInstance()

> `static` **getInstance**(): `ChatClient`

Defined in: ChatClient.ts:82

#### Returns

`ChatClient`

***

### handleGroupFileCallback()

> `protected` `static` **handleGroupFileCallback**(`methodName`, `self`, `groupId`, `filePath`, `callback?`): `void`

Defined in: \_\_internal\_\_/Base.ts:63

#### Parameters

##### methodName

`string`

##### self

`BaseManager`

##### groupId

`string`

##### filePath

`string`

##### callback?

[`ChatGroupFileStatusCallback`](../interfaces/ChatGroupFileStatusCallback.md)

#### Returns

`void`

#### Inherited from

`BaseManager.handleGroupFileCallback`

***

### handleMessageCallback()

> `protected` `static` **handleMessageCallback**(`methodName`, `self`, `message`, `callback?`): `void`

Defined in: \_\_internal\_\_/Base.ts:29

#### Parameters

##### methodName

`string`

##### self

`BaseManager`

##### message

[`ChatMessage`](ChatMessage.md)

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

#### Returns

`void`

#### Inherited from

`BaseManager.handleMessageCallback`
