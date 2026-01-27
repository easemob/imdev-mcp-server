[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatCmdMessageBody

# Class: ChatCmdMessageBody

Defined in: common/ChatMessage.ts:1538

The command message body.

## Extends

- [`ChatMessageBody`](ChatMessageBody.md)

## Constructors

### Constructor

> **new ChatCmdMessageBody**(`params`): `ChatCmdMessageBody`

Defined in: common/ChatMessage.ts:1543

#### Parameters

##### params

###### action

`string`

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### modifyCount?

`number`

#### Returns

`ChatCmdMessageBody`

#### Overrides

[`ChatMessageBody`](ChatMessageBody.md).[`constructor`](ChatMessageBody.md#constructor)

## Properties

### action

> **action**: `string`

Defined in: common/ChatMessage.ts:1542

The command action.

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

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`type`](ChatMessageBody.md#type)
