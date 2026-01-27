[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessage

# Class: ChatMessage

Defined in: common/ChatMessage.ts:355

The message class that defines a message that is to be sent or received.

For example, construct a text message to send:

```typescript
  let msg = ChatMessage.createTextMessage(
        'asteriskhx2',
        Date.now().toString(),
        ChatMessageChatType.PeerChat
      );
```

## Constructors

### Constructor

> **new ChatMessage**(`params`): `ChatMessage`

Defined in: common/ChatMessage.ts:505

Constructs a message.

#### Parameters

##### params

###### attributes?

`any`

###### body

`any`

###### chatType?

`number`

###### conversationId?

`string`

###### deliverOnlineOnly?

`boolean`

###### direction?

`string`

###### from?

`string`

###### groupAckCount?

`number`

###### hasDeliverAck?

`boolean`

###### hasRead?

`boolean`

###### hasReadAck?

`boolean`

###### isBroadcast?

`boolean`

###### isChatThread?

`boolean`

###### isContentReplaced?

`boolean`

###### isOnline?

`boolean`

###### localMsgId?

`string`

###### localTime?

`number`

###### msgId?

`string`

###### needGroupAck?

`boolean`

###### receiverList?

`string`[]

###### serverTime?

`number`

###### status?

`number`

###### to?

`string`

#### Returns

`ChatMessage`

## Properties

### attributes

> **attributes**: `Record`\<`string`, `any`\>

Defined in: common/ChatMessage.ts:441

The extension attribute of the message.

Value can be an object, string, string json, numerical value, undefined, null, etc.

**Note** Symbol and function types are not supported.

***

### body

> **body**: [`ChatMessageBody`](ChatMessageBody.md)

Defined in: common/ChatMessage.ts:445

The message body. See [ChatMessageBody](ChatMessageBody.md).

***

### chatType

> **chatType**: [`ChatMessageChatType`](../enumerations/ChatMessageChatType.md)

Defined in: common/ChatMessage.ts:425

The conversation type. See ChatType.

***

### conversationId

> **conversationId**: `string` = `''`

Defined in: common/ChatMessage.ts:368

The conversation ID.

***

### deliverOnlineOnly

> **deliverOnlineOnly**: `boolean`

Defined in: common/ChatMessage.ts:479

Whether the message is delivered only when the recipient(s) is/are online:
- `true`：The message is delivered only when the recipient(s) is/are online. If the recipient is offline, the message is discarded.
- (Default) `false`：The message is delivered when the recipient(s) is/are online. If the recipient(s) is/are offline, the message will not be delivered to them until they get online.

***

### direction

> **direction**: [`ChatMessageDirection`](../enumerations/ChatMessageDirection.md)

Defined in: common/ChatMessage.ts:429

The message direction. See [ChatMessageDirection](../enumerations/ChatMessageDirection.md).

***

### from

> **from**: `string` = `''`

Defined in: common/ChatMessage.ts:372

The user ID of the message sender.

***

### groupAckCount

> **groupAckCount**: `number` = `0`

Defined in: common/ChatMessage.ts:414

The number of group members that have read a message. Upon reading a message, members in the group call [ChatManager.sendGroupMessageReadAck](ChatManager.md#sendgroupmessagereadack) or [ChatManager.sendConversationReadAck](ChatManager.md#sendconversationreadack) to send a read receipt for a message or a conversation. To enable the read receipt function for group messages, you need to set [ChatOptions.requireAck](ChatOptions.md#requireack) to `true` during SDK initialization and set [needGroupAck](#needgroupack) to `true` when sending a message.

***

### hasDeliverAck

> **hasDeliverAck**: `boolean` = `false`

Defined in: common/ChatMessage.ts:396

Whether messages have arrived at the recipient during a one-to-one chat. If delivery receipts are required, recipient need to set [ChatOptions.requireDeliveryAck](ChatOptions.md#requiredeliveryack) to `true` during the SDK initialization. Delivery receipts are unavailable for group messages.

- `true`: Yes.
- (Default) `false`: No.

***

### hasRead

> **hasRead**: `boolean` = `false`

Defined in: common/ChatMessage.ts:421

Whether the the message is read by the recipient during a one-to-one chat or group chat. This parameter setting has connection with the number of unread messages in a conversation. Upon reading the message, the recipient calls  [ChatManager.markMessageAsRead](ChatManager.md#markmessageasread) to mark a message read or [ChatManager.markAllMessagesAsRead](ChatManager.md#markallmessagesasread)  to mark all unread messages in the conversation read.

- `true`: Yes.
- (Default) `false`: No.

***

### hasReadAck

> **hasReadAck**: `boolean` = `false`

Defined in: common/ChatMessage.ts:403

Whether the the read receipt from the recipient is received by the sender during a one-to-one chat. Upon reading the message, the recipient calls the [ChatManager.sendMessageReadAck](ChatManager.md#sendmessagereadack) or `{@link ChatManager.sendConversationReadAck}` method to send a read receipt to the sender. If read receipts are required, you need to set [ChatOptions.requireAck](ChatOptions.md#requireack) to `true` during the SDK initialization.

- `true`: Yes.
- (Default) `false`: No.

***

### isBroadcast

> **isBroadcast**: `boolean`

Defined in: common/ChatMessage.ts:493

Whether it is a global broadcast message.

***

### isChatThread

> **isChatThread**: `boolean`

Defined in: common/ChatMessage.ts:457

Whether it is a message in a message thread.

- `true`: Yes. In this case, you need to set the user ID of the message recipient to the message thread ID. See [to](#to).
- `false`: No.

**Note**

This parameter is valid only for group chat.

***

### isContentReplaced

> **isContentReplaced**: `boolean`

Defined in: common/ChatMessage.ts:500

Whether the message content is replaced.

It is valid after `ChatOptions.useReplacedMessageContents` is enabled.

***

### isOnline

> **isOnline**: `boolean`

Defined in: common/ChatMessage.ts:465

Whether it is a online message.

- `true`: Yes. In this case, if the application is running in the background, a notification window may pop up.
- `false`: No.

***

### localMsgId

> **localMsgId**: `string` = `''`

Defined in: common/ChatMessage.ts:364

The local message ID.

***

### localTime

> **localTime**: `number`

Defined in: common/ChatMessage.ts:385

The Unix timestamp when the message is created locally. The unit is millisecond.

***

### msgId

> **msgId**: `string`

Defined in: common/ChatMessage.ts:360

The message ID generated on the server.

***

### needGroupAck

> **needGroupAck**: `boolean` = `false`

Defined in: common/ChatMessage.ts:410

Whether read receipts are required for a group message.

- `true`: Yes.
- (Default) `false`: No.

***

### receiverList?

> `optional` **receiverList**: `string`[]

Defined in: common/ChatMessage.ts:488

The recipient list of a targeted message.

The default value is `undefined`, indicating that the message is sent to all members in the group or chat room.

This property is used only for messages in groups and chat rooms.

***

### serverTime

> **serverTime**: `number`

Defined in: common/ChatMessage.ts:389

The Unix timestamp when the server receives the message. The unit is millisecond.

***

### status

> **status**: [`ChatMessageStatus`](../enumerations/ChatMessageStatus.md) = `ChatMessageStatus.CREATE`

Defined in: common/ChatMessage.ts:433

The message sending status. See [ChatMessageStatus](../enumerations/ChatMessageStatus.md).

***

### to

> **to**: `string` = `''`

Defined in: common/ChatMessage.ts:381

The user ID of the message recipient:

- For the one-to-one chat, it is the user ID of the message recipient;
- For the group chat, it is the group ID;
- For the chat room chat, it is the chat room ID;
- For a message thread, it is the ID of the message thread.

***

### TAG

> `static` **TAG**: `string` = `'ChatMessage'`

Defined in: common/ChatMessage.ts:356

## Accessors

### getPinInfo

#### Get Signature

> **get** **getPinInfo**(): `Promise`\<[`ChatMessagePinInfo`](ChatMessagePinInfo.md) \| `undefined`\>

Defined in: common/ChatMessage.ts:1140

Get the list of pinned messages in the conversation.

##### Returns

`Promise`\<[`ChatMessagePinInfo`](ChatMessagePinInfo.md) \| `undefined`\>

***

### groupReadCount

#### Get Signature

> **get** **groupReadCount**(): `Promise`\<`number` \| `undefined`\>

Defined in: common/ChatMessage.ts:1126

Gets the count of read receipts of a group message.

##### Returns

`Promise`\<`number` \| `undefined`\>

***

### messagePriority

#### Set Signature

> **set** **messagePriority**(`p`): `void`

Defined in: common/ChatMessage.ts:1147

Set the chat room message priority.

##### Parameters

###### p

[`ChatRoomMessagePriority`](../enumerations/ChatRoomMessagePriority.md)

##### Returns

`void`

***

### reactionList

#### Get Signature

> **get** **reactionList**(): `Promise`\<[`ChatMessageReaction`](ChatMessageReaction.md)[]\>

Defined in: common/ChatMessage.ts:1119

Gets the list of Reactions.

##### Returns

`Promise`\<[`ChatMessageReaction`](ChatMessageReaction.md)[]\>

***

### threadInfo

#### Get Signature

> **get** **threadInfo**(): `Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

Defined in: common/ChatMessage.ts:1133

Gets details of a message thread.

##### Returns

`Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

## Methods

### createCmdMessage()

> `static` **createCmdMessage**(`targetId`, `action`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:1039

Creates a command message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### action

`string`

The command action.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- deliverOnlineOnly: Whether this command message is delivered only to the online users.
  - (Default) `true`: Yes.
  - `false`: No. The command message is delivered to users, regardless of their online or offline status.
- receiverList: The recipient list of a targeted message.

***

### createCombineMessage()

> `static` **createCombineMessage**(`targetId`, `messageIdList`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:943

Creates a combined message for sending.

#### Parameters

##### targetId

`string`

The message recipient. The field setting is determined by the conversation type:
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### messageIdList

`string`[]

A collection of message IDs. The list cannot be empty. It can contain a maximum of 300 message IDs.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### compatibleText?

`string`

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

###### summary?

`string`

###### title?

`string`

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- title: The title of the combined message.
- summary: The summary of the combined message.
- compatibleText: The compatible text of the combined message. This field is used for compatibility with SDK versions that do not support combined messages.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`：No.
- isOnline: Whether it is a online message.
  - `true`: Yes.
  - `false`：No.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online:
  - `true`: - `true`：The message is delivered only when the recipient(s) is/are online. If the recipient is offline, the message is discarded.
  - (Default) `false`：The message is delivered when the recipient(s) is/are online. If the recipient(s) is/are offline, the message will not be delivered to them until they get online.
- receiverList: The recipient list of a targeted message.

***

### createCustomMessage()

> `static` **createCustomMessage**(`targetId`, `event`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:1080

Creates a custom message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### event

`string`

The custom event.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### params

`Record`\<`string`, `string`\>

###### receiverList?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- params: The dictionary of custom parameters.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- receiverList: The recipient list of a targeted message.

***

### createFileMessage()

> `static` **createFileMessage**(`targetId`, `filePath`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:714

Creates a message with a file attachment for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### filePath

`string`

The file path.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### displayName

`string`

###### fileSize?

`number`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- displayName: The file name.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- isOnline: Whether it is a online message.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online.
- fileSize: The file size.
- receiverList: The recipient list of a targeted message.

***

### createImageMessage()

> `static` **createImageMessage**(`targetId`, `filePath`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:769

Creates an image message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### filePath

`string`

The image path.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### displayName

`string`

###### fileSize?

`number`

###### height

`number`

###### isChatThread?

`boolean`

###### isGif?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

###### sendOriginalImage?

`boolean`

###### thumbnailLocalPath?

`string`

###### width

`number`

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- displayName: The image name.
- thumbnailLocalPath: The image thumbnail path.
- sendOriginalImage: Whether to send the original image.
  - `true`: Yes.
  - (Default) `false`: If the image is equal to or greater than 100 KB, the SDK will compress it before sending the compressed image.
- width: The image width in pixels.
- height: The image height in pixels.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- isOnline: Whether it is a online message.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online.
- fileSize: The file size.
- receiverList: The recipient list of a targeted message.
- isGif: Whether the image is a GIF image.

***

### createLocationMessage()

> `static` **createLocationMessage**(`targetId`, `latitude`, `longitude`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:992

Creates a location message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### latitude

`string`

The latitude.

##### longitude

`string`

The longitude.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### address

`string`

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- address: The location details.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- receiverList: The recipient list of a targeted message.

***

### createReceiveMessage()

> `static` **createReceiveMessage**(`params`): `ChatMessage`

Defined in: common/ChatMessage.ts:1112

Creates a received message instance.

#### Parameters

##### params

`any`

The received message.

#### Returns

`ChatMessage`

The message object.

***

### createSendMessage()

> `static` **createSendMessage**(`params`): `ChatMessage`

Defined in: common/ChatMessage.ts:624

#### Parameters

##### params

###### body

[`ChatMessageBody`](ChatMessageBody.md)

###### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md)

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

###### targetId

`string`

#### Returns

`ChatMessage`

***

### createTextMessage()

> `static` **createTextMessage**(`targetId`, `content`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:668

Creates a text message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### content

`string`

The text content.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

###### targetLanguageCodes?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
 - targetLanguageCodes: The language code. See [ChatTextMessageBody.targetLanguageCodes](ChatTextMessageBody.md#targetlanguagecodes).
 -  isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- isOnline: Whether it is a online message.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online.
- receiverList: The recipient list of a targeted message.

***

### createVideoMessage()

> `static` **createVideoMessage**(`targetId`, `filePath`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:831

Creates a video message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### filePath

`string`

The path of the video file.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### displayName

`string`

###### duration

`number`

###### fileSize?

`number`

###### height

`number`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

###### thumbnailLocalPath

`string`

###### width

`number`

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- displayName: The video file name.
- thumbnailLocalPath: The path of the thumbnail of the first frame of video.
- duration: The video duration in seconds.
- width: The video thumbnail width in pixels.
- height: The video thumbnail height in pixels.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- isOnline: Whether it is a online message.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online.
- fileSize: The file size.
- receiverList: The recipient list of a targeted message.

***

### createVoiceMessage()

> `static` **createVoiceMessage**(`targetId`, `filePath`, `chatType`, `opt?`): `ChatMessage`

Defined in: common/ChatMessage.ts:888

Creates a voice message for sending.

#### Parameters

##### targetId

`string`

The user ID of the message recipient.
- For a one-to-one chat, it is the user ID of the peer user.
- For a group chat, it is the group ID.
- For a chat room, it is the chat room ID.

##### filePath

`string`

The path of the voice file.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md) = `ChatMessageChatType.PeerChat`

The conversation type. See ChatType.

##### opt?

###### deliverOnlineOnly?

`boolean`

###### displayName?

`string`

###### duration

`number`

###### fileSize?

`number`

###### isChatThread?

`boolean`

###### isOnline?

`boolean`

###### receiverList?

`string`[]

#### Returns

`ChatMessage`

The message instance.

#### Params

opt The extension parameters of the message.
- displayName: The voice file name.
- duration: The voice duration in seconds.
- isChatThread: Whether this message is a threaded message.
  - `true`: Yes.
  - (Default) `false`: No.
- isOnline: Whether it is a online message.
- deliverOnlineOnly: Whether the message is delivered only when the recipient(s) is/are online.
- fileSize: The file size.
- receiverList: The recipient list of a targeted message.
