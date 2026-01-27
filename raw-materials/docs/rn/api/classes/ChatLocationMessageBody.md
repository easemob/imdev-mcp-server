[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatLocationMessageBody

# Class: ChatLocationMessageBody

Defined in: common/ChatMessage.ts:1237

The location message body class.

## Extends

- [`ChatMessageBody`](ChatMessageBody.md)

## Constructors

### Constructor

> **new ChatLocationMessageBody**(`params`): `ChatLocationMessageBody`

Defined in: common/ChatMessage.ts:1250

#### Parameters

##### params

###### address

`string`

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### latitude

`string`

###### longitude

`string`

###### modifyCount?

`number`

#### Returns

`ChatLocationMessageBody`

#### Overrides

[`ChatMessageBody`](ChatMessageBody.md).[`constructor`](ChatMessageBody.md#constructor)

## Properties

### address

> **address**: `string`

Defined in: common/ChatMessage.ts:1241

The address.

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

### latitude

> **latitude**: `string`

Defined in: common/ChatMessage.ts:1245

The latitude.

***

### longitude

> **longitude**: `string`

Defined in: common/ChatMessage.ts:1249

The longitude.

***

### modifyCount?

> `optional` **modifyCount**: `number`

Defined in: common/ChatMessage.ts:1174

The number of times a message is modified.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`modifyCount`](ChatMessageBody.md#modifycount)

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`type`](ChatMessageBody.md#type)
