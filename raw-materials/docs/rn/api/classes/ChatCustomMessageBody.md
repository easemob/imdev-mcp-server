[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatCustomMessageBody

# Class: ChatCustomMessageBody

Defined in: common/ChatMessage.ts:1561

The custom message body.

## Extends

- [`ChatMessageBody`](ChatMessageBody.md)

## Constructors

### Constructor

> **new ChatCustomMessageBody**(`params`): `ChatCustomMessageBody`

Defined in: common/ChatMessage.ts:1570

#### Parameters

##### params

###### event

`string`

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### modifyCount?

`number`

###### params?

`Record`\<`string`, `string`\>

#### Returns

`ChatCustomMessageBody`

#### Overrides

[`ChatMessageBody`](ChatMessageBody.md).[`constructor`](ChatMessageBody.md#constructor)

## Properties

### event

> **event**: `string`

Defined in: common/ChatMessage.ts:1565

The event.

***

### lastModifyOperatorId?

> `optional` **lastModifyOperatorId**: `string`

Defined in: common/ChatMessage.ts:1164

The user ID of the operator that modified the message last time.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`lastModifyOperatorId`](ChatMessageBody.md#lastmodifyoperatorid)

***

### lastModifyTime?

> `optional` **lastModifyTime**: `number`

Defined in: common/ChatMessage.ts:1169

The UNIX timestamp of the last message modification, in milliseconds.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`lastModifyTime`](ChatMessageBody.md#lastmodifytime)

***

### modifyCount?

> `optional` **modifyCount**: `number`

Defined in: common/ChatMessage.ts:1174

The number of times a message is modified.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`modifyCount`](ChatMessageBody.md#modifycount)

***

### params?

> `optional` **params**: `Record`\<`string`, `string`\>

Defined in: common/ChatMessage.ts:1569

The custom params map.

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`type`](ChatMessageBody.md#type)
