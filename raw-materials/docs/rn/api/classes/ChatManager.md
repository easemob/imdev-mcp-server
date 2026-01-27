[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatManager

# Class: ChatManager

Defined in: ChatManager.ts:187

The chat manager class, responsible for sending and receiving messages, managing conversations (including loading and deleting conversations), and downloading attachments.

The sample code for sending a text message is as follows:

 ```typescript
 let msg = ChatMessage.createTextMessage(
   'asteriskhx2',
   Date.now().toString(),
   ChatMessageChatType.PeerChat
 );
 let callback = new (class s implements ChatMessageStatusCallback {
   onProgress(progress: number): void {
     chatlog.log('ConnectScreen.sendMessage.onProgress ', progress);
   }
   onError(error: ChatError): void {
     chatlog.log('ConnectScreen.sendMessage.onError ', error);
   }
   onSuccess(): void {
     chatlog.log('ConnectScreen.sendMessage.onSuccess');
   }
   onReadAck(): void {
     chatlog.log('ConnectScreen.sendMessage.onReadAck');
   }
   onDeliveryAck(): void {
     chatlog.log('ConnectScreen.sendMessage.onDeliveryAck');
   }
   onStatusChanged(status: ChatMessageStatus): void {
     chatlog.log('ConnectScreen.sendMessage.onStatusChanged ', status);
   }
 })();
 ChatClient.getInstance()
   .chatManager.sendMessage(msg, callback)
   .then((nmsg: ChatMessage) => {
     chatlog.log(`${msg}, ${nmsg}`);
   })
   .catch();
 ```

## Extends

- `BaseManager`

## Constructors

### Constructor

> **new ChatManager**(): `ChatManager`

Defined in: ChatManager.ts:191

#### Returns

`ChatManager`

#### Overrides

`BaseManager.constructor`

## Properties

### \_eventEmitter?

> `protected` `optional` **\_eventEmitter**: `NativeEventEmitter`

Defined in: \_\_internal\_\_/Base.ts:19

#### Inherited from

`BaseManager._eventEmitter`

***

### TAG

> `static` **TAG**: `string` = `'ChatManager'`

Defined in: ChatManager.ts:188

#### Overrides

`BaseManager.TAG`

## Methods

### addMessageListener()

> **addMessageListener**(`listener`): `void`

Defined in: ChatManager.ts:536

Adds a message listener.

#### Parameters

##### listener

[`ChatMessageEventListener`](../interfaces/ChatMessageEventListener.md)

The message listener to add.

#### Returns

`void`

***

### addReaction()

> **addReaction**(`reaction`, `msgId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2509

Adds a Reaction.

#### Parameters

##### reaction

`string`

The Reaction content.

##### msgId

`string`

The ID of the message for which the Reaction is added.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addRemoteAndLocalConversationsMark()

> **addRemoteAndLocalConversationsMark**(`convIds`, `mark`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3556

Marks conversations.

 This method marks conversations both locally and on the server.

#### Parameters

##### convIds

`string`[]

The list of conversation IDs.

##### mark

[`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)

The mark to add for the conversations. See [ChatConversationMarkType](../enumerations/ChatConversationMarkType.md).

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### createChatThread()

> **createChatThread**(`name`, `msgId`, `parentId`): `Promise`\<[`ChatMessageThread`](ChatMessageThread.md)\>

Defined in: ChatManager.ts:2719

Creates a message thread.

Each member of the group where the thread belongs can call this method.

Upon the creation of a message thread, the following will occur:

 - In a single-device login scenario, each member of the group to which the message thread belongs will receive the [ChatMessageEventListener.onChatMessageThreadCreated](../interfaces/ChatMessageEventListener.md#onchatmessagethreadcreated) callback.
  You can listen for message thread events by setting [ChatMessageEventListener](../interfaces/ChatMessageEventListener.md).

- In a multi-device login scenario, the devices will receive the [ChatMultiDeviceEventListener.onThreadEvent](../interfaces/ChatMultiDeviceEventListener.md#onthreadevent) callback.
  You can listen for message thread events by setting [ChatMultiDeviceEventListener](../interfaces/ChatMultiDeviceEventListener.md).

#### Parameters

##### name

`string`

The name of the new message thread. It can contain a maximum of 64 characters.

##### msgId

`string`

The ID of the parent message.

##### parentId

`string`

The parent ID, which is the group ID.

#### Returns

`Promise`\<[`ChatMessageThread`](ChatMessageThread.md)\>

If success, the new message thread object is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteAllMessageAndConversation()

> **deleteAllMessageAndConversation**(`clearServerData`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3643

Clears all conversations and all messages in them.

#### Parameters

##### clearServerData

`boolean` = `false`

Whether to clear all conversations and all messages in them on the server.
  - `true`：Yes. All conversations and all messages in them will be cleared on the server side.
  The current user cannot retrieve messages and conversations from the server, while this has no impact on other users.
 - (Default) `false`：No. All local conversations and all messages in them will be cleared, while those on the server remain.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteConversation()

> **deleteConversation**(`convId`, `withMessage`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1452

Deletes a conversation and its local messages from the local database.

#### Parameters

##### convId

`string`

The conversation ID.

##### withMessage

`boolean` = `true`

Whether to delete the historical messages with the conversation.
- (Default) `true`: Yes.
- `false`: No.

#### Returns

`Promise`\<`void`\>

Whether the conversation is successfully deleted.
- `true`: Yes.
- `false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteConversationAllMessages()

> **deleteConversationAllMessages**(`convId`, `convType`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1814

Deletes all messages in the conversation from both the memory and local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteMessage()

> **deleteMessage**(`convId`, `convType`, `msgId`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1744

Deletes a message from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### msgId

`string`

The ID of the message to delete.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteMessagesBeforeTimestamp()

> **deleteMessagesBeforeTimestamp**(`timestamp`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1842

Deletes local messages with timestamp that is before the specified one.

#### Parameters

##### timestamp

`number`

The specified Unix timestamp(milliseconds).

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteMessagesWithTimestamp()

> **deleteMessagesWithTimestamp**(`convId`, `convType`, `params`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1779

Deletes messages sent or received in a certain period from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### params

###### endTs

`number`

###### startTs

`number`

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Params

params
- startTs: The starting UNIX timestamp for message deletion. The unit is millisecond.
- endTs: The end UNIX timestamp for message deletion. The unit is millisecond.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteRemoteAndLocalConversationsMark()

> **deleteRemoteAndLocalConversationsMark**(`convIds`, `mark`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3585

Unmarks conversations.

 This method unmarks conversations both locally and on the server.

#### Parameters

##### convIds

`string`[]

The list of conversation IDs.

##### mark

[`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)

The conversation mark to remove. See [ChatConversationMarkType](../enumerations/ChatConversationMarkType.md).

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### destroyChatThread()

> **destroyChatThread**(`chatThreadId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2812

Destroys the message thread.

Only the owner or admins of the group where the message thread belongs can call this method.

**Note**

- In a single-device login scenario, each member of the group to which the message thread belongs will receive the [ChatMessageEventListener.onChatMessageThreadDestroyed](../interfaces/ChatMessageEventListener.md#onchatmessagethreaddestroyed) callback.
  You can listen for message thread events by setting [ChatMessageEventListener](../interfaces/ChatMessageEventListener.md).

- In a multi-device login scenario, the devices will receive the [ChatMultiDeviceEventListener.onThreadEvent](../interfaces/ChatMultiDeviceEventListener.md#onthreadevent) callback.
  You can listen for message thread events by setting [ChatMultiDeviceEventListener](../interfaces/ChatMultiDeviceEventListener.md).

#### Parameters

##### chatThreadId

`string`

The message thread ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### downloadAttachment()

> **downloadAttachment**(`message`, `callback?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:963

Downloads the message attachment.

You can also call this method if the attachment fails to be downloaded automatically.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The ID of the message with the attachment to be downloaded.

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

The listener that listens for message changes.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### downloadAttachmentInCombine()

> **downloadAttachmentInCombine**(`message`, `callback?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:900

Downloads the message attachment.

**Note** This method is only used to download messages attachment in combine type message or thread type.

**Note** The bottom layer will not get the original message object and will use the json converted message object.

You can also call this method if the attachment fails to be downloaded automatically.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The ID of the message with the attachment to be downloaded.

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

The listener that listens for message changes.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### downloadThumbnail()

> **downloadThumbnail**(`message`, `callback?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:987

Downloads the message thumbnail.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The ID of the message with the thumbnail to be downloaded. Only the image messages and video messages have a thumbnail.

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### downloadThumbnailInCombine()

> **downloadThumbnailInCombine**(`message`, `callback?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:931

Downloads the message thumbnail.

**Note** This method is only used to download messages thumbnail in combine type message.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The ID of the message with the thumbnail to be downloaded. Only the image messages and video messages have a thumbnail.

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~fetchAllConversations()~~

> **fetchAllConversations**(): `Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

Defined in: ChatManager.ts:1425

#### Returns

`Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

The conversation list of the current user.

#### Deprecated

2023-07-24 Use [fetchConversationsFromServerWithCursor](#fetchconversationsfromserverwithcursor) instead.

Gets the conversation list from the server.

**Note**

- To use this function, you need to contact our business manager to activate it.
- After this function is activated, users can pull 10 conversations within 7 days by default (each conversation contains the latest historical message).
- If you want to adjust the number of conversations or time limit, contact our business manager.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatThreadFromServer()

> **fetchChatThreadFromServer**(`chatThreadId`): `Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

Defined in: ChatManager.ts:3093

Gets the details of the message thread from the server.

#### Parameters

##### chatThreadId

`string`

The message thread ID.

#### Returns

`Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

If success, the details of the message thread are returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatThreadWithParentFromServer()

> **fetchChatThreadWithParentFromServer**(`parentId`, `cursor`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

Defined in: ChatManager.ts:3024

Uses the pagination to get the list of message threads in the specified group.

This method gets data from the server.

#### Parameters

##### parentId

`string`

The parent ID, which is the group ID.

##### cursor

`string` = `''`

The position from which to start getting data. At the first method call, if you set `cursor` to `null` or an empty string, the SDK will get data in the reverse chronological order of when message threads are created.

##### pageSize

`number` = `20`

The number of message threads that you expect to get on each page. The value range is [1,400].

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

If success, a list of message threads is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchCombineMessageDetail()

> **fetchCombineMessageDetail**(`message`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:3518

Gets the list of original messages included in a combined message.

A combined message contains one or more multiple original messages.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The combined message.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of original messages in the message body.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchConversationsByOptions()

> **fetchConversationsByOptions**(`option`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

Defined in: ChatManager.ts:3611

Gets the conversations from the server by conversation filter options.

#### Parameters

##### option

[`ChatConversationFetchOptions`](ChatConversationFetchOptions.md)

The conversation filter options. See [ChatConversationFetchOptions](ChatConversationFetchOptions.md).

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

The retrieved list of conversations. See [ChatCursorResult](ChatCursorResult.md).

***

### fetchConversationsFromServerWithCursor()

> **fetchConversationsFromServerWithCursor**(`cursor?`, `pageSize?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

Defined in: ChatManager.ts:3333

Gets the list of conversations from the server with pagination.

The SDK retrieves the list of conversations in the reverse chronological order of their active time (generally the timestamp of the last message).

If there is no message in the conversation, the SDK retrieves the list of conversations in the reverse chronological order of their creation time.

#### Parameters

##### cursor?

`string`

##### pageSize?

`number`

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

The list of retrieved conversations.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~fetchConversationsFromServerWithPage()~~

> **fetchConversationsFromServerWithPage**(`pageSize`, `pageNum`): `Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

Defined in: ChatManager.ts:3184

Gets conversations from the server with pagination.

#### Parameters

##### pageSize

`number`

The number of conversations to retrieve on each page.

##### pageNum

`number`

The current page number, starting from 1.

#### Returns

`Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

If success, the list of conversations is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-08-13 replace with [fetchConversationsFromServerWithCursor](#fetchconversationsfromserverwithcursor)

***

### fetchGroupAcks()

> **fetchGroupAcks**(`msgId`, `groupId`, `startAckId`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupMessageAck`](ChatGroupMessageAck.md)\>\>

Defined in: ChatManager.ts:1270

Uses the pagination to get read receipts for group messages from the server.

For how to send read receipts for group messages, see [sendConversationReadAck](#sendconversationreadack).

#### Parameters

##### msgId

`string`

The message ID.

##### groupId

`string`

##### startAckId

`string`

The starting read receipt ID for query. After this parameter is set, the SDK retrieves read receipts, from the specified one, in the reverse chronological order of when the server receives them.
                  If this parameter is set as `null` or an empty string, the SDK retrieves read receipts, from the latest one, in the reverse chronological order of when the server receives them.

##### pageSize

`number` = `0`

The number of read receipts for the group message that you expect to get on each page. The value range is [1,400].

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupMessageAck`](ChatGroupMessageAck.md)\>\>

The list of retrieved read receipts (excluding the one with the starting ID) and the cursor for the next query.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~fetchHistoryMessages()~~

> **fetchHistoryMessages**(`convId`, `convType`, `params`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessage`](ChatMessage.md)\>\>

Defined in: ChatManager.ts:1023

Uses the pagination to get messages in the specified conversation from the server.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### params

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### pageSize?

`number`

###### startMsgId?

`string`

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessage`](ChatMessage.md)\>\>

The list of retrieved messages (excluding the one with the starting ID) and the cursor for the next query.

#### Params

params
- pageSize: The number of messages that you expect to get on each page. The value range is [1,50].
- startMsgId: The starting message ID for query. After this parameter is set, the SDK retrieves messages, starting from the specified one, in the reverse chronological order of when the server receives them. If this parameter is set an empty string, the SDK retrieves messages, starting from the latest one, in the reverse chronological order of when the server receives them.
- direction: The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
                 - (Default) `ChatSearchDirection.Up`: Messages are retrieved in the descending order of the Unix timestamp included in them.
                 - `ChatSearchDirection.Down`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-08-15 Use [fetchHistoryMessagesByOptions](#fetchhistorymessagesbyoptions) instead.

***

### fetchHistoryMessagesByOptions()

> **fetchHistoryMessagesByOptions**(`convId`, `convType`, `params?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessage`](ChatMessage.md)\>\>

Defined in: ChatManager.ts:1074

retrieve the history message for the specified session from the server.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### params?

options: The parameter configuration class for pulling historical messages from the server. See [ChatFetchMessageOptions](ChatFetchMessageOptions.md).
- cursor: The cursor position from which to start querying data.
- pageSize: The number of messages that you expect to get on each page. The value range is [1,50].

###### cursor?

`string`

###### options?

[`ChatFetchMessageOptions`](ChatFetchMessageOptions.md)

###### pageSize?

`number`

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessage`](ChatMessage.md)\>\>

The list of retrieved messages (excluding the one with the starting ID) and the cursor for the next query.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchJoinedChatThreadFromServer()

> **fetchJoinedChatThreadFromServer**(`cursor`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

Defined in: ChatManager.ts:2938

Uses the pagination to get the list of message threads that the current user has joined.

#### Parameters

##### cursor

`string` = `''`

The position from which to start getting data. At the first method call, if you set `cursor` to `null` or an empty string, the SDK will get data in the reverse chronological order of when the user joins the message threads.

##### pageSize

`number` = `20`

The number of message threads that you expect to get on each page. The value range is [1,400].

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

If success, a list of message threads is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchJoinedChatThreadWithParentFromServer()

> **fetchJoinedChatThreadWithParentFromServer**(`parentId`, `cursor`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

Defined in: ChatManager.ts:2978

Uses the pagination to get the list of message threads that the current user has joined in the specified group.

This method gets data from the server.

#### Parameters

##### parentId

`string`

The parent ID, which is the group ID.

##### cursor

`string` = `''`

The position from which to start getting data. At the first method call, if you set `cursor` to `null` or an empty string, the SDK will get data in the reverse chronological order of when the user joins the message threads.

##### pageSize

`number` = `20`

The number of message threads that you expect to get on each page. The value range is [1,400].

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageThread`](ChatMessageThread.md)\>\>

If success, a list of message threads is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchLastMessageWithChatThread()

> **fetchLastMessageWithChatThread**(`chatThreadIds`): `Promise`\<`Map`\<`string`, [`ChatMessage`](ChatMessage.md)\>\>

Defined in: ChatManager.ts:3063

Gets the last reply in the specified message threads from the server.

#### Parameters

##### chatThreadIds

`string`[]

The list of message thread IDs to query. You can pass a maximum of 20 message thread IDs each time.

#### Returns

`Promise`\<`Map`\<`string`, [`ChatMessage`](ChatMessage.md)\>\>

If success, a list of last replies are returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMembersWithChatThreadFromServer()

> **fetchMembersWithChatThreadFromServer**(`chatThreadId`, `cursor`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

Defined in: ChatManager.ts:2898

Uses the pagination to get a list of members in the message thread.

Each member of the group to which the message thread belongs can call this method.

#### Parameters

##### chatThreadId

`string`

The message thread ID.

##### cursor

`string` = `''`

The position from which to start getting data. At the first method call, if you set `cursor` to `null` or an empty string, the SDK will get data in the chronological order of when members join the message thread.

##### pageSize

`number` = `20`

The number of members that you expect to get on each page. The value range is [1,400].

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

If success, the list of members in a message thread is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPinnedConversationsFromServerWithCursor()

> **fetchPinnedConversationsFromServerWithCursor**(`cursor?`, `pageSize?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

Defined in: ChatManager.ts:3374

Get the list of pinned conversations from the server with pagination.

The SDK returns the pinned conversations in the reverse chronological order of their pinning.

#### Parameters

##### cursor?

`string`

##### pageSize?

`number`

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatConversation`](ChatConversation.md)\>\>

The list of retrieved conversations.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPinnedMessages()

> **fetchPinnedMessages**(`convId`, `convType`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:3702

Gets the list of pinned messages in the conversation from the server.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of pinned messages. If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchReactionDetail()

> **fetchReactionDetail**(`msgId`, `reaction`, `cursor?`, `pageSize?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageReaction`](ChatMessageReaction.md)\>\>

Defined in: ChatManager.ts:2591

Gets the Reaction details.

#### Parameters

##### msgId

`string`

The message ID.

##### reaction

`string`

The Reaction content.

##### cursor?

`string`

The cursor position from which to start getting Reactions.

##### pageSize?

`number`

The number of Reactions you expect to get on each page.

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatMessageReaction`](ChatMessageReaction.md)\>\>

If success, the SDK returns the Reaction details and the cursor for the next query. The SDK returns `null` if all the data is fetched.
         If a failure occurs, an exception is thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchReactionList()

> **fetchReactionList**(`msgIds`, `groupId`, `chatType`): `Promise`\<`Map`\<`string`, [`ChatMessageReaction`](ChatMessageReaction.md)[]\>\>

Defined in: ChatManager.ts:2549

Gets the list of Reactions.

#### Parameters

##### msgIds

`string`[]

The message ID list.

##### groupId

`string`

The group ID, which is invalid only when the chat type is group chat.

##### chatType

[`ChatMessageChatType`](../enumerations/ChatMessageChatType.md)

The chat type.

#### Returns

`Promise`\<`Map`\<`string`, [`ChatMessageReaction`](ChatMessageReaction.md)[]\>\>

If success, the Reaction list is returned; otherwise, an exception is thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSupportedLanguages()

> **fetchSupportedLanguages**(): `Promise`\<[`ChatTranslateLanguage`](ChatTranslateLanguage.md)[]\>

Defined in: ChatManager.ts:2448

Gets all languages supported by the translation service.

#### Returns

`Promise`\<[`ChatTranslateLanguage`](ChatTranslateLanguage.md)[]\>

The list of languages supported for translation.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getAllConversations()

> **getAllConversations**(): `Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

Defined in: ChatManager.ts:1396

Gets all conversations from the local database.

Conversations will be first retrieved from the memory. If no conversation is found, the SDK retrieves from the local database.

#### Returns

`Promise`\<[`ChatConversation`](ChatConversation.md)[]\>

The retrieved conversations.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getConversation()

> **getConversation**(`convId`, `convType`, `createIfNeed`, `isChatThread`): `Promise`\<[`ChatConversation`](ChatConversation.md) \| `undefined`\>

Defined in: ChatManager.ts:1362

Gets the conversation by conversation ID and conversation type.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### createIfNeed

`boolean` = `true`

Whether to create a conversation if the specified conversation is not found:
- (Default) `true`: Yes.
- `false`: No.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.
- (Default) `false`: No.
- `true`: Yes.

#### Returns

`Promise`\<[`ChatConversation`](ChatConversation.md) \| `undefined`\>

The retrieved conversation object. The SDK returns `null` if the conversation is not found.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getConversationMessageCount()

> **getConversationMessageCount**(`convId`, `convType`, `isChatThread`): `Promise`\<`number`\>

Defined in: ChatManager.ts:1600

Gets the message count of the conversation.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`number`\>

The message count.
getMessageCount

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getConversationUnreadCount()

> **getConversationUnreadCount**(`convId`, `convType`, `isChatThread`): `Promise`\<`number`\>

Defined in: ChatManager.ts:1564

Gets the unread message count of the conversation.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`number`\>

The unread message count.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getConvMsgsWithKeyword()

> **getConvMsgsWithKeyword**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:2222

Gets messages that the specified user sends in a conversation in a certain period.

This method gets data from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### isChatThread?

`boolean`

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
- convId The conversation ID.
- convType The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).
- keywords The keywords for query.
- direction The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.
- timestamp The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
- searchScope The message search scope. See [ChatMessageSearchScope](../enumerations/ChatMessageSearchScope.md).
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.
- count The maximum number of messages to retrieve each time. The value range is [1,400].
- sender The user ID of the message sender. If you do not set this parameter, the SDK ignores this parameter when retrieving messages. use `senders` instead. 2025-07-22
- senders The user IDs of the message senders. If you do not set this parameter, the SDK ignores this parameter when retrieving messages.
- isChatThread Whether the conversation is a thread conversation.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getConvsMsgsWithKeyword()

> **getConvsMsgsWithKeyword**(`params`): `Promise`\<`Map`\<`string`, `string`[]\>\>

Defined in: ChatManager.ts:1227

Loads messages with the specified keyword from the local database, returning a dictionary containing conversation IDs and message ID arrays.
 The SDK returns messages in chronological order.

#### Parameters

##### params

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### from?

`string`

###### keywords

`string`

###### searchScope?

[`ChatMessageSearchScope`](../enumerations/ChatMessageSearchScope.md)

###### timestamp?

`number`

#### Returns

`Promise`\<`Map`\<`string`, `string`[]\>\>

A dictionary containing conversation IDs and message ID arrays. If no message is obtained, an empty dictionary is returned.

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getLatestMessage()

> **getLatestMessage**(`convId`, `convType`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

Defined in: ChatManager.ts:1486

Gets the latest message from the conversation.

**Note**

The operation does not change the unread message count.
If the conversation object does not exist, this method will create it.

The SDK gets the latest message from the memory first. If no message is found, the SDK loads the message from the local database and then puts it in the memory.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

The message instance. The SDK returns `undefined` if the message does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getLatestReceivedMessage()

> **getLatestReceivedMessage**(`convId`, `convType`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

Defined in: ChatManager.ts:1525

Gets the latest received message from the conversation.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

The message instance. The SDK returns `undefined` if the message does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessage()

> **getMessage**(`msgId`): `Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

Defined in: ChatManager.ts:746

Gets a message from the local database by message ID.

#### Parameters

##### msgId

`string`

The message ID.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md) \| `undefined`\>

The message.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessageCount()

> **getMessageCount**(): `Promise`\<`number`\>

Defined in: ChatManager.ts:3958

Gets the count of messages in the local database.

#### Returns

`Promise`\<`number`\>

The count of messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessageCountWithTimestamp()

> **getMessageCountWithTimestamp**(`params`): `Promise`\<`number`\>

Defined in: ChatManager.ts:3934

Gets the count of messages in the conversation.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### end

`number`

###### isChatThread?

`boolean`

###### start

`number`

#### Returns

`Promise`\<`number`\>

The count of messages.

#### Params

-
- convId: The conversation ID.
- convType: The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).
- isChatThread: Whether the conversation is a thread conversation.
- start: The start timestamp.
- end: The end timestamp.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMessagePinInfo()

> **getMessagePinInfo**(`messageId`): `Promise`\<[`ChatMessagePinInfo`](ChatMessagePinInfo.md) \| `undefined`\>

Defined in: ChatManager.ts:3779

Gets the pinning information of a message.

#### Parameters

##### messageId

`string`

The message ID.

#### Returns

`Promise`\<[`ChatMessagePinInfo`](ChatMessagePinInfo.md) \| `undefined`\>

The message pinning information. If the message does not exit or is not pinned, `undefined` is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~getMessages()~~

> **getMessages**(`convId`, `convType`, `startMsgId`, `direction`, `loadCount`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:2021

Retrieves messages of a specified quantity in a conversation from the local database.

The retrieved messages will also be put in the conversation in the memory according to the timestamp included in them.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### startMsgId

`string`

The starting message ID for query. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                  If this parameter is set an empty string, the SDK retrieves messages according to the message search direction while ignoring this parameter.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

##### loadCount

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,50].

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2023-07-24. Use [getMsgs](#getmsgs) instead.

***

### getMessagesWithIds()

> **getMessagesWithIds**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:772

Gets messages with the specified IDs from the local database.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

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

> **getMessagesWithKeyword**(`convId`, `convType`, `keywords`, `direction`, `timestamp`, `count`, `sender?`, `isChatThread?`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:2152

Gets messages that the specified user sends in a conversation in a certain period.

This method gets data from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### keywords

`string`

The keywords for query.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

##### timestamp

`number` = `-1`

The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### sender?

`string`

The user ID of the message sender. If you do not set this parameter, the SDK ignores this parameter when retrieving messages.

##### isChatThread?

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2023-07-24 This method is deprecated. Use [getConvMsgsWithKeyword](#getconvmsgswithkeyword) instead.

***

### ~~getMessagesWithMsgType()~~

> **getMessagesWithMsgType**(`convId`, `convType`, `msgType`, `direction`, `timestamp`, `count`, `sender?`, `isChatThread?`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:1878

Retrieves messages of a certain type in a conversation from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### msgType

[`ChatMessageType`](../enumerations/ChatMessageType.md)

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

##### timestamp

`number` = `-1`

The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### sender?

`string`

The message sender, which is the user ID of the peer user for one-to-one chat or group ID for group chat.

##### isChatThread?

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2023-07-24. Use [getMsgsWithMsgType](#getmsgswithmsgtype) instead.

***

### getMessageThread()

> **getMessageThread**(`msgId`): `Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

Defined in: ChatManager.ts:3121

Gets the details of the message thread from the memory.

#### Parameters

##### msgId

`string`

The message thread ID.

#### Returns

`Promise`\<[`ChatMessageThread`](ChatMessageThread.md) \| `undefined`\>

If success, the details of the message thread are returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~getMessageWithTimestamp()~~

> **getMessageWithTimestamp**(`convId`, `convType`, `startTime`, `endTime`, `direction`, `count`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:2305

Retrieves messages that are sent and received in a certain period in a conversation in the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### startTime

`number`

The starting Unix timestamp for query, in milliseconds.

##### endTime

`number`

The ending Unix timestamp for query, in milliseconds.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- (Default) `ChatSearchDirection.UP`: Messages are retrieved in the descending order of the Unix timestamp included in them.
- `ChatSearchDirection.DOWN`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

##### count

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding with the ones with the starting or ending timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2023-07-24 This method is deprecated. Use [getMsgWithTimestamp](#getmsgwithtimestamp) instead.

***

### getMsgs()

> **getMsgs**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:2081

Retrieves messages of a specified quantity in a conversation from the local database.

The retrieved messages will also be put in the conversation in the memory according to the timestamp included in them.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### isChatThread?

`boolean`

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

Defined in: ChatManager.ts:1170

Retrieves messages with keywords from the local database.

#### Parameters

##### params

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### from?

`string`

###### keywords

`string`

###### maxCount?

`number`

###### searchScope?

[`ChatMessageSearchScope`](../enumerations/ChatMessageSearchScope.md)

###### timestamp?

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getMsgsWithMsgType()

> **getMsgsWithMsgType**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:1944

Retrieves messages of a certain type in the conversation from the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### isChatThread?

`boolean`

###### msgType

[`ChatMessageType`](../enumerations/ChatMessageType.md)

###### sender?

`string`

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

Defined in: ChatManager.ts:2366

Retrieves messages that are sent and received in a certain period in a conversation in the local database.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### endTime

`number`

###### isChatThread?

`boolean`

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

> **getPinnedMessages**(`convId`, `convType`, `isChatThread`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:3742

Gets the pinned messages in a local conversation.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of pinned messages. If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getReactionList()

> **getReactionList**(`msgId`): `Promise`\<[`ChatMessageReaction`](ChatMessageReaction.md)[]\>

Defined in: ChatManager.ts:2658

Gets the list of Reactions from a message.

#### Parameters

##### msgId

`string`

The message ID.

#### Returns

`Promise`\<[`ChatMessageReaction`](ChatMessageReaction.md)[]\>

If success, the Reaction list is returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getThreadConversation()

> **getThreadConversation**(`convId`, `createIfNeed`): `Promise`\<[`ChatConversation`](ChatConversation.md) \| `undefined`\>

Defined in: ChatManager.ts:3150

Gets the thread conversation by conversation ID.

#### Parameters

##### convId

`string`

The conversation ID.

##### createIfNeed

`boolean` = `true`

Whether to create a conversation if the specified conversation is not found:
- (Default) `true`: Yes.
- `false`: No.

#### Returns

`Promise`\<[`ChatConversation`](ChatConversation.md) \| `undefined`\>

The retrieved conversation object. The SDK returns `null` if the conversation is not found.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getUnreadCount()

> **getUnreadCount**(): `Promise`\<`number`\>

Defined in: ChatManager.ts:812

Gets the count of the unread messages.

#### Returns

`Promise`\<`number`\>

The count of the unread messages.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### groupAckCount()

> **groupAckCount**(`msgId`): `Promise`\<`number` \| `undefined`\>

Defined in: ChatManager.ts:2685

Gets the number of members that have read the group message.

#### Parameters

##### msgId

`string`

The message ID.

#### Returns

`Promise`\<`number` \| `undefined`\>

If success, the SDK returns the number of members that have read the group message; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### importMessages()

> **importMessages**(`messages`): `Promise`\<`void`\>

Defined in: ChatManager.ts:873

Imports messages to the local database.

You can only import messages that you sent or received.

#### Parameters

##### messages

[`ChatMessage`](ChatMessage.md)[]

The messages to import.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### insertMessage()

> **insertMessage**(`message`): `Promise`\<`void`\>

Defined in: ChatManager.ts:830

Inserts a message to the conversation in the local database.

For example, when a notification messages is received, a message can be constructed and written to the conversation. If the message to insert already exits (msgId or localMsgId is existed), the insertion fails.

The message will be inserted based on the Unix timestamp included in it. Upon message insertion, the SDK will automatically update attributes of the conversation, including `latestMessage`.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The message to be inserted.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### joinChatThread()

> **joinChatThread**(`chatThreadId`): `Promise`\<[`ChatMessageThread`](ChatMessageThread.md)\>

Defined in: ChatManager.ts:2757

Joins a message thread.

Each member of the group where the message thread belongs can call this method.

In a multi-device login scenario, note the following:

- The devices will receive the [ChatMultiDeviceEventListener.onThreadEvent](../interfaces/ChatMultiDeviceEventListener.md#onthreadevent) callback.

- You can listen for message thread events by setting [ChatMultiDeviceEventListener](../interfaces/ChatMultiDeviceEventListener.md).

#### Parameters

##### chatThreadId

`string`

The message thread ID.

#### Returns

`Promise`\<[`ChatMessageThread`](ChatMessageThread.md)\>

If success, the message thread details [ChatMessageThread](ChatMessageThread.md) are returned; otherwise, an exception will be thrown.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### leaveChatThread()

> **leaveChatThread**(`chatThreadId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2785

Leaves a message thread.

Each member in the message thread can call this method.

In a multi-device login scenario, note the following:

- The devices will receive the [ChatMultiDeviceEventListener.onThreadEvent](../interfaces/ChatMultiDeviceEventListener.md#onthreadevent) callback.

- You can listen for message thread events by setting [ChatMultiDeviceEventListener](../interfaces/ChatMultiDeviceEventListener.md).

#### Parameters

##### chatThreadId

`string`

The ID of the message thread that the current user wants to leave.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### markAllConversationsAsRead()

> **markAllConversationsAsRead**(): `Promise`\<`void`\>

Defined in: ChatManager.ts:799

Marks all conversations as read.

This method is for the local conversations only.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### markAllMessagesAsRead()

> **markAllMessagesAsRead**(`convId`, `convType`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1671

Marks all messages as read.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### markMessageAsRead()

> **markMessageAsRead**(`convId`, `convType`, `msgId`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1636

Marks a message as read.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### msgId

`string`

The message ID.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~modifyMessageBody()~~

> **modifyMessageBody**(`msgId`, `body`): `Promise`\<[`ChatMessage`](ChatMessage.md)\>

Defined in: ChatManager.ts:3443

Modifies a message.

After this method is called to modify a message, both the local message and the message on the server are modified.

This method can only modify a text message in one-to-one chats or group chats, but not in chat rooms.

#### Parameters

##### msgId

`string`

The ID of the message to modify.

##### body

[`ChatMessageBody`](ChatMessageBody.md)

The modified text message body. See [ChatTextMessageBody](ChatTextMessageBody.md).

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)\>

The modified message. See [ChatMessageBody](ChatMessageBody.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2025-07-21. Use [modifyMsgBody](#modifymsgbody) instead.

***

### modifyMsgBody()

> **modifyMsgBody**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)\>

Defined in: ChatManager.ts:3487

Modifies a message both in the local storage and server.

 - Text and custom message: Both the message body `body` and extension information `ext` can be modified.
 - Image/voice/video/file/combined message: Only the message extension field `ext` can be modified.
 - Command message: This type of message cannot be modified.

 Note that the message ID cannot be changed.

#### Parameters

##### params

###### body?

[`ChatMessageBody`](ChatMessageBody.md)

###### ext?

`Record`\<`string`, `any`\>

###### msgId

`string`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)\>

The modified message. See [ChatMessage](ChatMessage.md).

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### pinConversation()

> **pinConversation**(`convId`, `isPinned`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3413

Sets whether to pin a conversation.

#### Parameters

##### convId

`string`

The conversation ID.

##### isPinned

`boolean`

Whether to pin a conversation:
- `true`：Yes.
- `false`: No. The conversation is unpinned.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### pinMessage()

> **pinMessage**(`messageId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3664

Pins a message.

#### Parameters

##### messageId

`string`

The message ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### recallMessage()

> **recallMessage**(`msgId`, `option?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:724

For a one-to-one chat conversation, only the message sender can recall the message that is sent successfully. If the message expires, the recall fails.

For a group/chat room conversation, except the message sender, the group/chat room owner and administrators can recall messages sent in the group/chat room. If the message expires, only the group/chat room owner and administrators can recall it.

#### Parameters

##### msgId

`string`

The message ID.

##### option?

The extension information.

###### ext?

`string`

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllMessageListener()

> **removeAllMessageListener**(): `void`

Defined in: ChatManager.ts:554

Removes all message listeners.

#### Returns

`void`

***

### removeConversationFromServer()

> **removeConversationFromServer**(`convId`, `convType`, `isDeleteMessage`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1311

Deletes the specified conversation and its historical messages from the server.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### isDeleteMessage

`boolean` = `true`

Whether to delete the historical messages with the conversation.
- (Default) `true`: Yes.
- `false`: No.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMemberWithChatThread()

> **removeMemberWithChatThread**(`chatThreadId`, `memberId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2868

Removes a member from the message thread.

Only the owner or admins of the group where the message thread belongs and the message thread creator can call this method.

The removed member will receive the [ChatMessageEventListener.onChatMessageThreadUserRemoved](../interfaces/ChatMessageEventListener.md#onchatmessagethreaduserremoved) callback.

You can listen for message thread events by setting [ChatMessageEventListener](../interfaces/ChatMessageEventListener.md).

#### Parameters

##### chatThreadId

`string`

The message thread ID.

##### memberId

`string`

The user ID of the member to be removed from the message thread.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMessageListener()

> **removeMessageListener**(`listener`): `void`

Defined in: ChatManager.ts:546

Removes the message listener.

#### Parameters

##### listener

[`ChatMessageEventListener`](../interfaces/ChatMessageEventListener.md)

The message listener to remove.

#### Returns

`void`

***

### removeMessagesFromServerWithMsgIds()

> **removeMessagesFromServerWithMsgIds**(`convId`, `convType`, `msgIds`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3226

Deletes messages from the conversation (from both local storage and server).

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation Type.

##### msgIds

`string`[]

The IDs of messages to delete from the current conversation.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMessagesFromServerWithTimestamp()

> **removeMessagesFromServerWithTimestamp**(`convId`, `convType`, `timestamp`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3280

Deletes messages from the conversation (from both local storage and server).

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation Type.

##### timestamp

`number`

The message timestamp in millisecond. The messages with the timestamp smaller than the specified one will be deleted.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMessagesWithTimestamp()

> **removeMessagesWithTimestamp**(`params`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3903

Delete the local and server messages of the current user. The server messages of other users in the single chat or group chat with the user will not be affected and can be obtained through roaming.

#### Parameters

##### params

convId: The conversation ID.
- convType: The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).
- timestamp: Messages before this timestamp will be deleted.
- isChatThread: Whether the conversation is a thread conversation.

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### isChatThread?

`boolean`

###### timestamp

`number`

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeReaction()

> **removeReaction**(`reaction`, `msgId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2528

Deletes a Reaction.

#### Parameters

##### reaction

`string`

The Reaction to delete.

##### msgId

`string`

The message ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### reportMessage()

> **reportMessage**(`msgId`, `tag`, `reason`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2634

Reports an inappropriate message.

#### Parameters

##### msgId

`string`

The ID of the message to report.

##### tag

`string`

The tag of the inappropriate message. You need to type a custom tag, like `porn` or `ad`.

##### reason

`string`

The reporting reason. You need to type a specific reason.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### resendMessage()

> **resendMessage**(`message`, `callback`): `Promise`\<`void`\>

Defined in: ChatManager.ts:596

Resends a message.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The message object to be resent.

##### callback

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

The listener that listens for message changes.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### searchMessages()

> **searchMessages**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:3810

Searches for messages.

#### Parameters

##### params

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### from?

`string`

###### isChatThread?

`boolean`

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
- isChatThread: Whether the conversation is a thread conversation.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### searchMessagesInConversation()

> **searchMessagesInConversation**(`params`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:3858

Searches for messages in a conversation.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### count?

`number`

###### direction?

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### from?

`string`

###### isChatThread?

`boolean`

###### msgTypes

[`ChatMessageType`](../enumerations/ChatMessageType.md)[]

###### timestamp

`number`

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of messages that meet the search criteria.

#### Params

- params
- convId: The conversation ID.
- convType: The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).
- msgTypes: The message types to search for. See [ChatMessageType](../enumerations/ChatMessageType.md).
- timestamp: The timestamp of the message to search for.
- count: The number of messages to search for. The value range is [1,100]. The default value is 20.
- from: The message ID to start searching from.
- direction: The search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
- isChatThread: Whether the conversation is a thread conversation.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~searchMsgFromDB()~~

> **searchMsgFromDB**(`keywords`, `timestamp`, `maxCount`, `from`, `direction`): `Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

Defined in: ChatManager.ts:1125

Retrieves messages with keywords in a conversation from the local database.

#### Parameters

##### keywords

`string`

The keywords for query.

##### timestamp

`number` = `-1`

The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
                 If you set this parameter as a negative value, the SDK retrieves messages, starting from the current time, in the descending order of the timestamp included in them.

##### maxCount

`number` = `20`

The maximum number of messages to retrieve each time. The value range is [1,400].

##### from

`string` = `''`

The user ID of the message sender. If you do not set this parameter, the SDK ignores this parameter when retrieving messages.

##### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md) = `ChatSearchDirection.UP`

The message search direction. See [ChatSearchDirection](../enumerations/ChatSearchDirection.md).
                 - (Default) `ChatSearchDirection.Up`: Messages are retrieved in the descending order of the Unix timestamp included in them.
                 - `ChatSearchDirection.Down`: Messages are retrieved in the ascending order of the Unix timestamp included in them.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)[]\>

The list of retrieved messages (excluding the one with the starting timestamp). If no message is obtained, an empty list is returned.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-04-22. Use [getMsgsWithKeyword](#getmsgswithkeyword) instead.

***

### sendConversationReadAck()

> **sendConversationReadAck**(`convId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:704

Sends the conversation read receipt to the server.

**Note**

- This method is valid only for one-to-one conversations.
- After this method is called, the sever will set the message status from unread to read.
- The SDK triggers the [ChatMessageEventListener.onConversationRead](../interfaces/ChatMessageEventListener.md#onconversationread) callback on the client of the message sender, notifying that the messages are read. This also applies to multi-device scenarios.

#### Parameters

##### convId

`string`

The conversation ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### sendGroupMessageReadAck()

> **sendGroupMessageReadAck**(`msgId`, `groupId`, `opt?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:667

Sends the group message receipt to the server.

**Note**

- This method takes effect only after you set [ChatOptions.requireAck](ChatOptions.md#requireack) and [ChatMessage.needGroupAck](ChatMessage.md#needgroupack) as `true`.
- This method applies to group messages only. To send a read receipt for a one-to-one chat message, you can call [sendMessageReadAck](#sendmessagereadack); to send a conversation read receipt, you can call [sendConversationReadAck](#sendconversationreadack).

#### Parameters

##### msgId

`string`

The message ID.

##### groupId

`string`

The group ID.

##### opt?

The extension information, which is a custom keyword that specifies a custom action or command.

###### content

`string`

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### sendMessage()

> **sendMessage**(`message`, `callback?`): `Promise`\<`void`\>

Defined in: ChatManager.ts:572

Sends a message.

**Note**

- For a voice or image message or a message with an attachment, the SDK will automatically upload the attachment.
- You can determine whether to upload the attachment to the chat sever by setting [ChatOptions](ChatOptions.md).

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The message object to be sent. Ensure that you set this parameter.

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

The listener that listens for message changes.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### sendMessageReadAck()

> **sendMessageReadAck**(`message`): `Promise`\<`void`\>

Defined in: ChatManager.ts:639

Sends the read receipt to the server.

This method applies to one-to-one chats only.

**Note**

This method takes effect only when you set [ChatOptions.requireAck](ChatOptions.md#requireack) as `true`.

To send a group message read receipt, you can call [sendGroupMessageReadAck](#sendgroupmessagereadack).

We recommend that you call [sendConversationReadAck](#sendconversationreadack) when opening the chat page. In other cases, you can call this method to reduce the number of method calls.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

The message for which the read receipt is to be sent.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setConversationExtension()

> **setConversationExtension**(`convId`, `convType`, `ext`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2475

Sets the extension information of the conversation.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### ext

The extension information. This parameter must be key-value type.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatManager.ts:196

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

#### Overrides

`BaseManager.setNativeListener`

***

### translateMessage()

> **translateMessage**(`msg`, `languages`): `Promise`\<[`ChatMessage`](ChatMessage.md)\>

Defined in: ChatManager.ts:2425

Translates a text message.

#### Parameters

##### msg

[`ChatMessage`](ChatMessage.md)

The text message to translate.

##### languages

`string`[]

The target languages.

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)\>

The translation.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unpinMessage()

> **unpinMessage**(`messageId`): `Promise`\<`void`\>

Defined in: ChatManager.ts:3681

Unpins a message.

#### Parameters

##### messageId

`string`

The message ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateChatThreadName()

> **updateChatThreadName**(`chatThreadId`, `newName`): `Promise`\<`void`\>

Defined in: ChatManager.ts:2836

Changes the name of the message thread.

Only the owner or admins of the group where the message thread belongs and the message thread creator can call this method.

Each member of the group to which the message thread belongs will receive the [ChatMessageEventListener.onChatMessageThreadUpdated](../interfaces/ChatMessageEventListener.md#onchatmessagethreadupdated) callback.

You can listen for message thread events by setting [ChatMessageEventListener](../interfaces/ChatMessageEventListener.md).

#### Parameters

##### chatThreadId

`string`

The message thread ID.

##### newName

`string`

The new message thread name. It can contain a maximum of 64 characters.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateConversationMessage()

> **updateConversationMessage**(`convId`, `convType`, `msg`, `isChatThread`): `Promise`\<`void`\>

Defined in: ChatManager.ts:1707

Updates a message in the local database.

After you modify a message, the message ID remains unchanged and the SDK automatically updates properties of the conversation, like `latestMessage`.

**note** If the conversation object does not exist, this method will create it.

#### Parameters

##### convId

`string`

The conversation ID.

##### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type. See [ChatConversationType](../enumerations/ChatConversationType.md).

##### msg

[`ChatMessage`](ChatMessage.md)

The ID of the message to update.

##### isChatThread

`boolean` = `false`

Whether the conversation is a thread conversation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateMessage()

> **updateMessage**(`message`): `Promise`\<[`ChatMessage`](ChatMessage.md)\>

Defined in: ChatManager.ts:849

Updates the local message.

The message will be updated both in the memory and local database.

#### Parameters

##### message

[`ChatMessage`](ChatMessage.md)

#### Returns

`Promise`\<[`ChatMessage`](ChatMessage.md)\>

The updated message.

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
