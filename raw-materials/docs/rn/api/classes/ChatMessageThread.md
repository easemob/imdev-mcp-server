[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageThread

# Class: ChatMessageThread

Defined in: common/ChatMessageThread.ts:6

The chat message thread class.

## Constructors

### Constructor

> **new ChatMessageThread**(`params`): `ChatMessageThread`

Defined in: common/ChatMessageThread.ts:46

Creates a message thread.

#### Parameters

##### params

###### createAt

`number`

###### lastMessage?

`any`

###### memberCount

`number`

###### msgCount

`number`

###### msgId

`string`

###### owner

`string`

###### parentId

`string`

###### threadId

`string`

###### threadName

`string`

#### Returns

`ChatMessageThread`

## Properties

### createAt

> **createAt**: `number`

Defined in: common/ChatMessageThread.ts:38

The Unix timestamp when the message thread is created. The unit is millisecond.

***

### lastMessage?

> `optional` **lastMessage**: [`ChatMessage`](ChatMessage.md)

Defined in: common/ChatMessageThread.ts:42

The last reply in the message thread. If it is empty, the last message is withdrawn.

***

### memberCount

> **memberCount**: `number`

Defined in: common/ChatMessageThread.ts:30

The count of members in the message thread.

***

### msgCount

> **msgCount**: `number`

Defined in: common/ChatMessageThread.ts:34

The count of messages in the message thread.

***

### msgId

> **msgId**: `string`

Defined in: common/ChatMessageThread.ts:22

The ID of the parent message of the message thread.

***

### owner

> **owner**: `string`

Defined in: common/ChatMessageThread.ts:18

The creator of the message thread.

***

### parentId

> **parentId**: `string`

Defined in: common/ChatMessageThread.ts:26

The group ID where the message thread belongs.

***

### threadId

> **threadId**: `string`

Defined in: common/ChatMessageThread.ts:10

The message thread ID.

***

### threadName

> **threadName**: `string`

Defined in: common/ChatMessageThread.ts:14

The name of the message thread.
