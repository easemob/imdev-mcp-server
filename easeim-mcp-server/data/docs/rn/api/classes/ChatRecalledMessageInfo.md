[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatRecalledMessageInfo

# Class: ChatRecalledMessageInfo

Defined in: common/ChatMessage.ts:1717

## Constructors

### Constructor

> **new ChatRecalledMessageInfo**(`params`): `ChatRecalledMessageInfo`

Defined in: common/ChatMessage.ts:1748

Creates a recall message instance.

#### Parameters

##### params

###### recalledBy

`string`

###### recalledConvId?

`string`

###### recalledExt?

`string`

###### recalledMessage?

[`ChatMessage`](ChatMessage.md)

###### recalledMessageId

`string`

#### Returns

`ChatRecalledMessageInfo`

#### Params

params -
- recalledMessageId: The message ID of the recalled message.
- recalledMessage: The recalled message.
- recalledBy: The user ID of the operator that recalls the message.
- recalledExt: The extension information of the recalled message.
- recalledConvId: The conversation ID of the recalled message.

## Properties

### recalledBy

> **recalledBy**: `string`

Defined in: common/ChatMessage.ts:1729

The user ID of the operator that recalls the message.

***

### recalledConvId?

> `optional` **recalledConvId**: `string`

Defined in: common/ChatMessage.ts:1737

The conversation ID of the recalled message.

***

### recalledExt?

> `optional` **recalledExt**: `string`

Defined in: common/ChatMessage.ts:1733

The extension information of the recalled message.

***

### recalledMessage?

> `optional` **recalledMessage**: [`ChatMessage`](ChatMessage.md)

Defined in: common/ChatMessage.ts:1725

The recalled message.

***

### recalledMessageId

> **recalledMessageId**: `string`

Defined in: common/ChatMessage.ts:1721

The message ID of the recalled message.
