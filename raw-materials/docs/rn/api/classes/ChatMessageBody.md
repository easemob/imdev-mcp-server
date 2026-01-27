[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageBody

# Abstract Class: ChatMessageBody

Defined in: common/ChatMessage.ts:1155

The message body base class.

## Extended by

- [`ChatTextMessageBody`](ChatTextMessageBody.md)
- [`ChatLocationMessageBody`](ChatLocationMessageBody.md)
- [`ChatCmdMessageBody`](ChatCmdMessageBody.md)
- [`ChatCustomMessageBody`](ChatCustomMessageBody.md)

## Constructors

### Constructor

> `protected` **new ChatMessageBody**(`type`, `opt?`): `ChatMessageBody`

Defined in: common/ChatMessage.ts:1176

#### Parameters

##### type

[`ChatMessageType`](../enumerations/ChatMessageType.md)

##### opt?

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### modifyCount?

`number`

#### Returns

`ChatMessageBody`

## Properties

### lastModifyOperatorId?

> `optional` **lastModifyOperatorId**: `string`

Defined in: common/ChatMessage.ts:1164

The user ID of the operator that modified the message last time.

***

### lastModifyTime?

> `optional` **lastModifyTime**: `number`

Defined in: common/ChatMessage.ts:1169

The UNIX timestamp of the last message modification, in milliseconds.

***

### modifyCount?

> `optional` **modifyCount**: `number`

Defined in: common/ChatMessage.ts:1174

The number of times a message is modified.

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).
