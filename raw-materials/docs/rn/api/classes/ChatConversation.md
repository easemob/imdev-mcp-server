[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatConversation

# Class: ChatConversation

Defined in: common/ChatConversation.ts:122

The conversation class, which defines one-to-one conversations, group conversations, and chat room conversations.

Each type of conversation involves messages that are sent and received.

You can get the conversation name by conversation type:
- One-to-one chat: See [ChatUserInfoManager.fetchUserInfoById](ChatUserInfoManager.md#fetchuserinfobyid).
- Group chat: See ChatGroup.getGroupWithId.
- Chat room: See ChatRoom.fetchChatRoomInfoFromServer.

## Constructors

### Constructor

> **new ChatConversation**(`params`): `ChatConversation`

Defined in: common/ChatConversation.ts:168

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### ext?

`any`

###### isChatThread?

`boolean`

###### isPinned?

`boolean`

###### marks?

[`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)[]

###### pinnedTime?

`number`

###### remindType?

[`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

#### Returns

`ChatConversation`

## Properties

### convId

> **convId**: `string`

Defined in: common/ChatConversation.ts:126

The conversation ID.

***

### convType

> **convType**: [`ChatConversationType`](../enumerations/ChatConversationType.md)

Defined in: common/ChatConversation.ts:130

The conversation type.

***

### ext?

> `optional` **ext**: `any`

Defined in: common/ChatConversation.ts:145

The conversation extension.

***

### isChatThread

> **isChatThread**: `boolean`

Defined in: common/ChatConversation.ts:141

Whether the current conversation is a thread conversation.

- `true`: Yes.
- `false`: No.

**Note**

This parameter is valid only for group chat.

***

### isPinned?

> `optional` **isPinned**: `boolean`

Defined in: common/ChatConversation.ts:152

Whether the conversation is pinned:

- `true`: Yes.
- (Default) `false`: No.

***

### marks?

> `optional` **marks**: [`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)[]

Defined in: common/ChatConversation.ts:161

The conversation marks.

***

### pinnedTime?

> `optional` **pinnedTime**: `number`

Defined in: common/ChatConversation.ts:156

The UNIX timestamp when the conversation is pinned. The unit is millisecond. This value is `0` when the conversation is not pinned.

***

### remindType?

> `optional` **remindType**: [`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

Defined in: common/ChatConversation.ts:166

The conversation remind type.

## Methods

### deleteAllMessages()

> **deleteAllMessages**(): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:423

Deletes all the messages of the conversation.

This method deletes all the messages of the conversation from both the memory and local database.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteMessage()

> **deleteMessage**(`msgId`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:386

Deletes a message from the local database.

#### Parameters

##### msgId

`string`

The ID of message to delete.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteMessagesWithTimestamp()

> **deleteMessagesWithTimestamp**(`params`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:404

Deletes messages sent or received in a certain period from the local database.

#### Parameters

##### params

###### endTs

`number`

###### startTs

`number`

#### Returns

`Promise`\<`void`\>

#### Params

params
- startTs: The starting UNIX timestamp for message deletion. The unit is millisecond.
- endTs: The end UNIX timestamp for message deletion. The unit is millisecond.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPinnedMessages()

> **fetchPinnedMessages**(): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:787

Gets the pinned messages in the conversation from the server.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of pinned messages. If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getLatestMessage()

> **getLatestMessage**(): `Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

Defined in: common/ChatConversation.ts:283

Gets the latest message from the conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

The message instance. The SDK returns `undefined` if the message does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getLatestReceivedMessage()

> **getLatestReceivedMessage**(): `Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

Defined in: common/ChatConversation.ts:298

Gets the latest message received in the conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

The message instance. The SDK returns `undefined` if the message does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessageCount()

> **getMessageCount**(): `Promise`\<`number`\>

Defined in: common/ChatConversation.ts:246

Gets the count of messages in the conversation.

#### Returns

`Promise`\<`number`\>

The count of messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessageCountWithTimestamp()

> **getMessageCountWithTimestamp**(`start`, `end`): `Promise`\<`number`\>

Defined in: common/ChatConversation.ts:263

Gets the count of messages in the conversation.

#### Parameters

##### start

`number`

##### end

`number`

#### Returns

`Promise`\<`number`\>

The count of messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~getMessages()~~

> **getMessages**(`startMsgId`, `direction`, `loadCount`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:524

Gets messages of a certain quantity in a conversation from the local database.

**Note**

The obtained messages will also join the existing messages of the conversation stored in the memory.

#### Parameters

##### startMsgId

`string`

The starting message ID for query. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                  If this parameter is set an empty string, the SDK retrieves messages according to the message search direction while ignoring this parameter.
                 - If `direction` is set as `ChatSearchDirection.UP`, the SDK retrieves messages, starting from the latest one, in the descending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.
                - If `direction` is set as `ChatSearchDirection.DOWN`, the SDK retrieves messages, starting from the oldest one, in the ascending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### loadCount

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The message list (excluding the ones with the starting or ending timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-04-17 This method is deprecated. Use [getMsgs](#getmsgs) instead.

***

### getMessagesWithIds()

> **getMessagesWithIds**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:580

Gets messages with the specified IDs from the local database.

#### Parameters

##### params

###### msgIds

`string`[]

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages. If no message is obtained, an empty list is returned.

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~getMessagesWithKeyword()~~

> **getMessagesWithKeyword**(`keywords`, `direction`, `timestamp`, `count`, `sender?`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:607

Gets messages with keywords in a conversation in the local database.

#### Parameters

##### keywords

`string`

The keywords for query.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.Up`: Messages are retrieved in the descending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.
- `ChatSearchDirection.Down`: Messages are retrieved in the ascending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### timestamp

`number` = `-1`

The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### sender?

`string`

The user ID or group ID for retrieval. Usually, it is the conversation ID.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-04-17 This method is deprecated. Use [getMsgsWithKeyword](#getmsgswithkeyword) instead.

***

### ~~getMessagesWithMsgType()~~

> **getMessagesWithMsgType**(`msgType`, `direction`, `timestamp`, `count`, `sender?`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:448

Gets messages of a certain type that a specified user sends in a conversation.

#### Parameters

##### msgType

[`ChatMessageType`](../enumerations/ChatMessageType.md)

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### timestamp

`number` = `-1`

The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### sender?

`string`

The user ID or group ID for retrieval. Usually, it is the conversation ID.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-04-17 This method is deprecated. Use [getMsgsWithMsgType](#getmsgswithmsgtype) instead.

***

### ~~getMessageWithTimestamp()~~

> **getMessageWithTimestamp**(`startTime`, `endTime`, `direction`, `count`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:681

Gets messages that are sent and received in a certain period in a conversation in the local database.

#### Parameters

##### startTime

`number`

The starting Unix timestamp for search. The unit is millisecond.

##### endTime

`number`

The ending Unix timestamp for search. The unit is millisecond.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp ([ChatOptions.sortMessageByServerTime](ChatOptions.md#sortmessagebyservertime)) included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the ones with the starting or ending timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-04-17 This method is deprecated. Use [getMsgWithTimestamp](#getmsgwithtimestamp) instead.

***

### getMsgs()

> **getMsgs**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:558

Gets messages of a specified quantity in a conversation from the local database.

The retrieved messages will also be put in the conversation in the memory according to the timestamp included in them.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### loadCount?

`number`

###### startMsgId

`string`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMsgsWithKeyword()

> **getMsgsWithKeyword**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:649

Gets messages that the specified user sends in a conversation in a certain period.

This method gets data from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### keywords

`string`

###### searchScope?

[`ChatMessageSearchScope`](../enumerations/ChatMessageSearchScope.md)

###### sender?

`string`

###### senders?

`string`[]

###### timestamp?

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Params

-
- keywords The keywords for query.
- direction The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.
- timestamp The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
- searchScope The message search scope. See [ChatMessageSearchScope](../enumerations/ChatMessageSearchScope.md).
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.
- count The maximum number of messages to retrieve each time. The value range is [1,400].
- sender The user ID or group ID for retrieval. Usually, it is the conversation ID. use `senders` instead. 2025-07-22
- senders The user IDs of the message senders. If you do not set this parameter, the SDK ignores this parameter when retrieving messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMsgsWithMsgType()

> **getMsgsWithMsgType**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:487

Gets messages of a certain type in the conversation from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### msgType

[`ChatMessageType`](../enumerations/ChatMessageType.md)

###### sender?

`string`

###### senders?

`string`[]

###### timestamp?

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMsgWithTimestamp()

> **getMsgWithTimestamp**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:715

Gets messages that are sent and received in a certain period in a conversation in the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### endTime

`number`

###### startTime

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding with the ones with the starting or ending timestamp). If no message is obtained, an empty list is returned.

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getPinnedMessages()

> **getPinnedMessages**(): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:772

Gets the pinned messages in the conversation from the local database.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of pinned messages. If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getUnreadCount()

> **getUnreadCount**(): `Promise`\<`number`\>

Defined in: common/ChatConversation.ts:233

Gets the count of unread messages in the conversation.

#### Returns

`Promise`\<`number`\>

The count of unread messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### markAllMessagesAsRead()

> **markAllMessagesAsRead**(): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:346

Marks all messages as read.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### markMessageAsRead()

> **markMessageAsRead**(`msgId`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:332

Marks a message as read.

#### Parameters

##### msgId

`string`

The message ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### name()

> **name**(): `Promise`\<`string` \| `undefined`\>

Defined in: common/ChatConversation.ts:193

Gets the conversation ID.

#### Returns

`Promise`\<`string` \| `undefined`\>

The conversation ID.

***

### removeMessagesFromServerWithMsgIds()

> **removeMessagesFromServerWithMsgIds**(`msgIds`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:736

Deletes messages from the conversation (from both local storage and server).

#### Parameters

##### msgIds

`string`[]

The IDs of messages to delete from the current conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMessagesFromServerWithTimestamp()

> **removeMessagesFromServerWithTimestamp**(`timestamp`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:754

Deletes messages from the conversation (from both local storage and server).

#### Parameters

##### timestamp

`number`

The message timestamp in millisecond. The messages with the timestamp smaller than the specified one will be deleted.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMessagesWithTimestamp()

> **removeMessagesWithTimestamp**(`params`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:831

Delete the local and server messages of the current user. The server messages of other users in the single chat or group chat with the user will not be affected and can be obtained through roaming.

#### Parameters

##### params

timestamp: Messages before this timestamp will be deleted.

###### timestamp

`number`

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### searchMessages()

> **searchMessages**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: common/ChatConversation.ts:809

Searches for messages.

#### Parameters

##### params

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### from?

`string`

###### msgTypes

[`ChatMessageType`](../enumerations/ChatMessageType.md)[]

###### timestamp

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of messages that meet the search criteria.

#### Params

- params
- msgTypes: The message types to search for. See [ChatMessageType](../enumerations/ChatMessageType.md).
- timestamp: The timestamp of the message to search for.
- count: The number of messages to search for. The value range is [1,100]. The default value is 20.
- from: The message ID to start searching from.
- direction: The search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setConversationExtension()

> **setConversationExtension**(`ext`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:313

Sets the extension information of the conversation.

#### Parameters

##### ext

The extension information of the conversation. This parameter must be in the key-value format.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateMessage()

> **updateMessage**(`msg`): `Promise`\<`void`\>

Defined in: common/ChatConversation.ts:363

Updates a message in the local database.

After you modify a message, the message ID remains unchanged and the SDK automatically updates attributes of the conversation, like `latestMessage`.

#### Parameters

##### msg

[`ChatMessage`](ChatMessage.md)

The message instance.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).
