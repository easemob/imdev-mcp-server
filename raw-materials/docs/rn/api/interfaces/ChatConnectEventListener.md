[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatConnectEventListener

# Interface: ChatConnectEventListener

Defined in: ChatEvents.ts:339

The connection event listener.

In the case of disconnection in an unstable network environment, the app using the SDK receives the `onDisconnected` callback.

You do not need to reconnect manually as the chat SDK will handle it automatically.

There are two connection-related callbacks:
- `onConnected`: Occurs when the connection is set up.
- `onDisconnected`: Occurs when the connection breaks down.

Adds a connection event listener:

 ```typescript
 let listener = new (class s implements ChatConnectEventListener {
   onTokenWillExpire(): void {
     chatlog.log('ConnectScreen.onTokenWillExpire');
   }
   onTokenDidExpire(): void {
     chatlog.log('ConnectScreen.onTokenDidExpire');
   }
   onConnected(): void {
     chatlog.log('ConnectScreen.onConnected');
   }
   onDisconnected(errorCode?: number): void {
     chatlog.log('ConnectScreen.onDisconnected', errorCode);
   }
 })();
 ChatClient.getInstance().addConnectionListener(listener);
 ```
Removes a connection event listener:

 ```typescript
 ChatClient.getInstance().removeConnectionListener(listener);
 ```

## Methods

### onAppActiveNumberReachLimit()?

> `optional` **onAppActiveNumberReachLimit**(): `void`

Defined in: ChatEvents.ts:369

The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit.

The user is disconnected by the server.

#### Returns

`void`

***

### onConnected()?

> `optional` **onConnected**(): `void`

Defined in: ChatEvents.ts:343

Occurs when the SDK connects to the chat server successfully.

#### Returns

`void`

***

### onDisconnected()?

> `optional` **onDisconnected**(): `void`

Defined in: ChatEvents.ts:350

Occurs when the SDK disconnects from the chat server.

The user also remains logged in. For the cases where the user is disconnected by the server, see [ChatConnectEventListener.onAppActiveNumberReachLimit](#onappactivenumberreachlimit), [ChatConnectEventListener.onUserDidLoginFromOtherDeviceWithInfo](#onuserdidloginfromotherdevicewithinfo), [ChatConnectEventListener.onUserDidRemoveFromServer](#onuserdidremovefromserver), [ChatConnectEventListener.onUserDidForbidByServer](#onuserdidforbidbyserver), [ChatConnectEventListener.onUserDidChangePassword](#onuserdidchangepassword), [ChatConnectEventListener.onUserDidLoginTooManyDevice](#onuserdidlogintoomanydevice), [ChatConnectEventListener.onUserKickedByOtherDevice](#onuserkickedbyotherdevice), [ChatConnectEventListener.onUserAuthenticationFailed](#onuserauthenticationfailed).

#### Returns

`void`

***

### onOfflineMessageSyncFinish()?

> `optional` **onOfflineMessageSyncFinish**(): `void`

Defined in: ChatEvents.ts:379

Callback invoked when the synchronization of offline messages finishes.

#### Returns

`void`

***

### onOfflineMessageSyncStart()?

> `optional` **onOfflineMessageSyncStart**(): `void`

Defined in: ChatEvents.ts:374

Callback invoked when the synchronization of offline messages starts.

#### Returns

`void`

***

### onTokenDidExpire()?

> `optional` **onTokenDidExpire**(): `void`

Defined in: ChatEvents.ts:362

Occurs when the token has expired.

#### Returns

`void`

***

### onTokenWillExpire()?

> `optional` **onTokenWillExpire**(): `void`

Defined in: ChatEvents.ts:357

Occurs when the token is about to expire.

This event occurs from when 20% of the validity period is left.

#### Returns

`void`

***

### onUserAuthenticationFailed()?

> `optional` **onUserAuthenticationFailed**(): `void`

Defined in: ChatEvents.ts:447

Occurs when the current chat user authentication failed.

This callback is triggered in the following typical scenarios: The token expires or token authentication fails.

The user is disconnected by the server.

#### Returns

`void`

***

### onUserDidChangePassword()?

> `optional` **onUserDidChangePassword**(): `void`

Defined in: ChatEvents.ts:424

Occurs when the current chat user changed the password.

The user is disconnected by the server.

#### Returns

`void`

***

### onUserDidForbidByServer()?

> `optional` **onUserDidForbidByServer**(): `void`

Defined in: ChatEvents.ts:417

Occurs when the current chat user is banned from accessing the server.

The user is disconnected by the server.

#### Returns

`void`

***

### ~~onUserDidLoginFromOtherDevice()?~~

> `optional` **onUserDidLoginFromOtherDevice**(`deviceName?`): `void`

Defined in: ChatEvents.ts:388

Occurs when the current user account is logged in to another device.

The user is disconnected by the server.

#### Parameters

##### deviceName?

`string`

#### Returns

`void`

#### Deprecated

2024-08-15 replace with [onUserDidLoginFromOtherDeviceWithInfo](#onuserdidloginfromotherdevicewithinfo)

***

### onUserDidLoginFromOtherDeviceWithInfo()?

> `optional` **onUserDidLoginFromOtherDeviceWithInfo**(`params`): `void`

Defined in: ChatEvents.ts:400

Occurs when the current user account is logged in to another device.

The user is disconnected by the server.

#### Parameters

##### params

###### deviceName

`string`

###### ext?

`string`

#### Returns

`void`

#### Params

-
- Param [deviceName] The device name.
- Param [ext] The extension of user information. see [ChatOptions.loginExtraInfo](../classes/ChatOptions.md#loginextrainfo).

***

### onUserDidLoginTooManyDevice()?

> `optional` **onUserDidLoginTooManyDevice**(): `void`

Defined in: ChatEvents.ts:431

Occurs when the current chat user logged in to many devices.

The user is disconnected by the server.

#### Returns

`void`

***

### onUserDidRemoveFromServer()?

> `optional` **onUserDidRemoveFromServer**(): `void`

Defined in: ChatEvents.ts:410

Occurs when the current chat user is removed from the server.

The user is disconnected by the server.

#### Returns

`void`

***

### onUserKickedByOtherDevice()?

> `optional` **onUserKickedByOtherDevice**(): `void`

Defined in: ChatEvents.ts:438

Occurs when the current chat user is kicked out of the app by another device.

The user is disconnected by the server.

#### Returns

`void`
