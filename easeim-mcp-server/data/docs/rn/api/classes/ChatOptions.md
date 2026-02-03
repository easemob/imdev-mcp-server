[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatOptions

# Class: ChatOptions

Defined in: common/ChatOptions.ts:8

The chat setting class that defines parameters and options of the SDK, including whether to encrypt the messages before sending them and whether to automatically accept the friend invitations.

## Constructors

### Constructor

> **new ChatOptions**(`params`): `ChatOptions`

Defined in: common/ChatOptions.ts:267

#### Parameters

##### params

###### acceptInvitationAlways?

`boolean`

###### appId

`string`

###### appKey

`string`

###### areaCode?

[`ChatAreaCode`](../enumerations/ChatAreaCode.md)

###### autoAcceptGroupInvitation?

`boolean`

###### autoLogin?

`boolean`

###### customDeviceName?

`string`

###### customOSType?

`number`

###### debugModel?

`boolean`

###### deleteMessagesAsExitChatRoom?

`boolean`

###### deleteMessagesAsExitGroup?

`boolean`

###### dnsUrl?

`string`

###### dohVendor?

`number`

###### enableDNSConfig?

`boolean`

###### enableEmptyConversation?

`boolean`

###### enableTLS?

`boolean`

###### imPort?

`number`

###### imServer?

`string`

###### isAutoDownload?

`boolean`

###### isChatRoomOwnerLeaveAllowed?

`boolean`

###### loginExtraInfo?

`string`

###### logTag?

`string`

###### logTimestamp?

`boolean`

###### messagesReceiveCallbackIncludeSend?

`boolean`

###### pushConfig?

[`ChatPushConfig`](ChatPushConfig.md)

###### regardImportMessagesAsRead?

`boolean`

###### requireAck?

`boolean`

###### requireDeliveryAck?

`boolean`

###### restServer?

`string`

###### serverTransfer?

`boolean`

###### sortMessageByServerTime?

`boolean`

###### uikitVersion?

`string`

###### useReplacedMessageContents?

`boolean`

###### usingHttpsOnly?

`boolean`

###### webSocketPort?

`number`

###### webSocketServer?

`string`

###### workPathCopiable?

`boolean`

#### Returns

`ChatOptions`

#### Deprecated

Use [withAppId](#withappid) and [withAppKey](#withappkey) instead.

## Properties

### acceptInvitationAlways

> **acceptInvitationAlways**: `boolean`

Defined in: common/ChatOptions.ts:45

Whether to accept friend invitations from other users automatically.

- `true`: Yes.
- (Default) `false`: No.

***

### appId

> **appId**: `string`

Defined in: common/ChatOptions.ts:16

It is the unique identifier of your app.

***

### appKey

> **appKey**: `string`

Defined in: common/ChatOptions.ts:12

The App Key you get from the console when creating a chat app. It is the unique identifier of your app.

***

### areaCode

> **areaCode**: [`ChatAreaCode`](../enumerations/ChatAreaCode.md)

Defined in: common/ChatOptions.ts:185

The area code.
This attribute is used to restrict the scope of accessible edge nodes. The default value is `GLOB`. See [ChatAreaCode](../enumerations/ChatAreaCode.md).
This attribute can be set only when you call [ChatClient.init](ChatClient.md#init). The attribute setting cannot be changed during the app runtime.

***

### autoAcceptGroupInvitation

> **autoAcceptGroupInvitation**: `boolean`

Defined in: common/ChatOptions.ts:52

Whether to accept group invitations automatically.

- `true`: Yes.
- (Default) `false`: No.

***

### autoLogin

> **autoLogin**: `boolean`

Defined in: common/ChatOptions.ts:23

Whether to enable automatic login.

- (Default) `true`: Enables automatic login.
- `false`: Disables automatic login.

***

### customDeviceName?

> `optional` **customDeviceName**: `string`

Defined in: common/ChatOptions.ts:203

Custom device name.

This attribute does not take effect when `customOSType` is set to `-1`.

An application scenario is as follows: User A wants to log in to a mobile phone and a tablet with the same user account. Then the user sets `customOSType` to `1` and `customDeviceName` to `foo`.

***

### customOSType?

> `optional` **customOSType**: `number`

Defined in: common/ChatOptions.ts:208

Custom system type.

***

### debugModel

> **debugModel**: `boolean`

Defined in: common/ChatOptions.ts:30

Whether to output the debug information.
- `true`: Yes.
- (Default) `false`: No.

***

### deleteMessagesAsExitChatRoom

> **deleteMessagesAsExitChatRoom**: `boolean`

Defined in: common/ChatOptions.ts:87

Whether to delete the historical messages of the chat room in the memory and local database when leaving the chat room (either voluntarily or passively).

- (Default) `true`: Yes.
- `false`: No.

***

### deleteMessagesAsExitGroup

> **deleteMessagesAsExitGroup**: `boolean`

Defined in: common/ChatOptions.ts:80

Whether to delete the historical messages of the group stored in the memory and local database when leaving a group (either voluntarily or passively).

- (Default) `true`: Yes.
- `false`: No.

***

### dnsUrl

> **dnsUrl**: `string`

Defined in: common/ChatOptions.ts:139

The URL of the DNS server.

***

### dohVendor?

> `optional` **dohVendor**: `number`

Defined in: common/ChatOptions.ts:262

The DoH vendor.

0: disable 1.china 2.global

This property is used to specify the DoH vendor when `enableDNSConfig` is `true`.

***

### enableDNSConfig

> **enableDNSConfig**: `boolean`

Defined in: common/ChatOptions.ts:135

Whether to disable DNS.

When enabled, the restServer, imServer, and webSocketServer parameters will be ignored.

- (Default) `true`: Yes.
- `false`: No. DNS needs to be disabled for private deployment.

***

### enableEmptyConversation

> **enableEmptyConversation**: `boolean`

Defined in: common/ChatOptions.ts:193

Whether to include empty conversations when the SDK loads conversations from the local database:

- `true`: Yes. Empty conversations are included.
- (Default) `false`: No. Empty conversations are excluded.

***

### enableTLS

> **enableTLS**: `boolean`

Defined in: common/ChatOptions.ts:167

Whether to enable TLS connection, which takes effect during initialization and is `false` by default.

***

### imPort

> **imPort**: `number`

Defined in: common/ChatOptions.ts:163

The custom port of the IM server.

The custom port is used when you implement data isolation and data security during private deployment.

If you need the port, contact our business manager.

***

### imServer

> **imServer**: `string`

Defined in: common/ChatOptions.ts:155

The custom address of the IM message server.

This address is used when you implement data isolation and data security during private deployment.

If you need the address, contact our business manager.

***

### isAutoDownload

> **isAutoDownload**: `boolean`

Defined in: common/ChatOptions.ts:122

Whether to automatically download the thumbnail.

- (Default) `true`: Yes.
- `false`: No.

***

### isChatRoomOwnerLeaveAllowed

> **isChatRoomOwnerLeaveAllowed**: `boolean`

Defined in: common/ChatOptions.ts:94

Whether to allow the chat room owner to leave the chat room.

- (Default) `true`: Yes. Even if the chat room owner leaves the chat room, the owner still has all privileges, except for receiving messages in the chat room.
- `false`: No.

***

### loginExtraInfo?

> `optional` **loginExtraInfo**: `string`

Defined in: common/ChatOptions.ts:222

Extra login information. Can be a string in json format.

This attribute is used to pass extra login information to the server. The server can use this information to verify the user's identity.

***

### logTag?

> `optional` **logTag**: `string`

Defined in: common/ChatOptions.ts:34

Global flag for printing logs.

***

### logTimestamp?

> `optional` **logTimestamp**: `boolean`

Defined in: common/ChatOptions.ts:38

Whether to activate the timestamp of the log.

***

### messagesReceiveCallbackIncludeSend

> **messagesReceiveCallbackIncludeSend**: `boolean`

Defined in: common/ChatOptions.ts:173

Whether the sent message is included in `ChatMessageEventListener.onMessagesReceived`.
- `true`: Yes. Besides the received message, the sent message is also included in `ChatMessageEventListener.onMessagesReceived`.
- (Default)`false`: No. Only the received message is included in `ChatMessageEventListener.onMessagesReceived`.

***

### pushConfig?

> `optional` **pushConfig**: [`ChatPushConfig`](ChatPushConfig.md)

Defined in: common/ChatOptions.ts:126

The push configuration.

***

### regardImportMessagesAsRead

> **regardImportMessagesAsRead**: `boolean`

Defined in: common/ChatOptions.ts:179

Whether to set messages from the server side as read.
- `true`: Yes.
- (Default) `false`: No.

***

### requireAck

> **requireAck**: `boolean`

Defined in: common/ChatOptions.ts:62

Whether to require the message read receipt from the recipient.

- (Default) `true`: Yes.
- `false`: No.

This property does not take effect for [ChatManager.sendConversationReadAck](ChatManager.md#sendconversationreadack).

***

### requireDeliveryAck

> **requireDeliveryAck**: `boolean`

Defined in: common/ChatOptions.ts:73

Whether to require the delivery receipt.

**Note**

Only valid for single chat messages. [ChatMessageChatType.PeerChat](../enumerations/ChatMessageChatType.md#peerchat)

- `true`: Yes.
- (Default) `false`: No.

***

### restServer

> **restServer**: `string`

Defined in: common/ChatOptions.ts:147

The custom address of the REST server.

This address is used when you implement data isolation and data security during private deployment.

If you need the address, contact our business manager.

***

### serverTransfer

> **serverTransfer**: `boolean`

Defined in: common/ChatOptions.ts:115

Whether to upload the message attachments automatically to the chat server.

- (Default) `true`: Yes.
- `false`: No. A custom path is used.

***

### sortMessageByServerTime

> **sortMessageByServerTime**: `boolean`

Defined in: common/ChatOptions.ts:101

Whether to sort the messages in the reverse chronological order of the time when they are received by the server.

- (Default) `true`: Yes;
- `false`: No. Messages are sorted in the reverse chronological order of the time when they are created.

***

### uikitVersion?

> `optional` **uikitVersion**: `string`

Defined in: common/ChatOptions.ts:239

The UIKit version.

- (Default) undefined.

***

### useReplacedMessageContents

> **useReplacedMessageContents**: `boolean`

Defined in: common/ChatOptions.ts:215

Whether the server returns the sender the text message with the content replaced during text moderation:
- `true`: Yes.
- (Default) `false`: No. The server returns the original message to the sender.

***

### usingHttpsOnly

> **usingHttpsOnly**: `boolean`

Defined in: common/ChatOptions.ts:108

Whether only HTTPS is used for REST operations.

- (Default) `true`: Only HTTPS is supported.
- `false`: Both HTTP and HTTPS are allowed.

***

### webSocketPort?

> `optional` **webSocketPort**: `number`

Defined in: common/ChatOptions.ts:253

The WebSocket server port.

This property is effective only when `enableDnsConfig` is `false`.

***

### webSocketServer?

> `optional` **webSocketServer**: `string`

Defined in: common/ChatOptions.ts:246

The WebSocket server.

This property is effective only when `enableDnsConfig` is `false`.

***

### workPathCopiable?

> `optional` **workPathCopiable**: `boolean`

Defined in: common/ChatOptions.ts:231

Whether the work path is copyable.

**Note** This attribute is used only for the iOS platform.

default is `false`

## Methods

### withAppId()

> `static` **withAppId**(`params`): `ChatOptions`

Defined in: common/ChatOptions.ts:357

#### Parameters

##### params

###### acceptInvitationAlways?

`boolean`

###### appId

`string`

###### areaCode?

[`ChatAreaCode`](../enumerations/ChatAreaCode.md)

###### autoAcceptGroupInvitation?

`boolean`

###### autoLogin?

`boolean`

###### customDeviceName?

`string`

###### customOSType?

`number`

###### debugModel?

`boolean`

###### deleteMessagesAsExitChatRoom?

`boolean`

###### deleteMessagesAsExitGroup?

`boolean`

###### dnsUrl?

`string`

###### dohVendor?

`number`

###### enableDNSConfig?

`boolean`

###### enableEmptyConversation?

`boolean`

###### enableTLS?

`boolean`

###### imPort?

`number`

###### imServer?

`string`

###### isAutoDownload?

`boolean`

###### isChatRoomOwnerLeaveAllowed?

`boolean`

###### loginExtraInfo?

`string`

###### logTag?

`string`

###### logTimestamp?

`boolean`

###### messagesReceiveCallbackIncludeSend?

`boolean`

###### pushConfig?

[`ChatPushConfig`](ChatPushConfig.md)

###### regardImportMessagesAsRead?

`boolean`

###### requireAck?

`boolean`

###### requireDeliveryAck?

`boolean`

###### restServer?

`string`

###### serverTransfer?

`boolean`

###### sortMessageByServerTime?

`boolean`

###### uikitVersion?

`string`

###### useReplacedMessageContents?

`boolean`

###### usingHttpsOnly?

`boolean`

###### webSocketPort?

`number`

###### webSocketServer?

`string`

###### workPathCopiable?

`boolean`

#### Returns

`ChatOptions`

***

### withAppKey()

> `static` **withAppKey**(`params`): `ChatOptions`

Defined in: common/ChatOptions.ts:401

#### Parameters

##### params

###### acceptInvitationAlways?

`boolean`

###### appKey

`string`

###### areaCode?

[`ChatAreaCode`](../enumerations/ChatAreaCode.md)

###### autoAcceptGroupInvitation?

`boolean`

###### autoLogin?

`boolean`

###### customDeviceName?

`string`

###### customOSType?

`number`

###### debugModel?

`boolean`

###### deleteMessagesAsExitChatRoom?

`boolean`

###### deleteMessagesAsExitGroup?

`boolean`

###### dnsUrl?

`string`

###### dohVendor?

`number`

###### enableDNSConfig?

`boolean`

###### enableEmptyConversation?

`boolean`

###### enableTLS?

`boolean`

###### imPort?

`number`

###### imServer?

`string`

###### isAutoDownload?

`boolean`

###### isChatRoomOwnerLeaveAllowed?

`boolean`

###### loginExtraInfo?

`string`

###### logTag?

`string`

###### logTimestamp?

`boolean`

###### messagesReceiveCallbackIncludeSend?

`boolean`

###### pushConfig?

[`ChatPushConfig`](ChatPushConfig.md)

###### regardImportMessagesAsRead?

`boolean`

###### requireAck?

`boolean`

###### requireDeliveryAck?

`boolean`

###### restServer?

`string`

###### serverTransfer?

`boolean`

###### sortMessageByServerTime?

`boolean`

###### uikitVersion?

`string`

###### useReplacedMessageContents?

`boolean`

###### usingHttpsOnly?

`boolean`

###### webSocketPort?

`number`

###### webSocketServer?

`string`

###### workPathCopiable?

`boolean`

#### Returns

`ChatOptions`
