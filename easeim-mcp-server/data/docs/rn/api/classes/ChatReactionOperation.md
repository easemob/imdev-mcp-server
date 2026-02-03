[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatReactionOperation

# Class: ChatReactionOperation

Defined in: common/ChatMessageReaction.ts:12

Reaction Operation

## Constructors

### Constructor

> **new ChatReactionOperation**(`params`): `ChatReactionOperation`

Defined in: common/ChatMessageReaction.ts:25

#### Parameters

##### params

###### operate

[`ChatReactionOperate`](../enumerations/ChatReactionOperate.md)

###### reaction

`string`

###### userId

`string`

#### Returns

`ChatReactionOperation`

## Properties

### operate

> **operate**: [`ChatReactionOperate`](../enumerations/ChatReactionOperate.md)

Defined in: common/ChatMessageReaction.ts:24

Operate type.

***

### reaction

> **reaction**: `string`

Defined in: common/ChatMessageReaction.ts:20

Changed reaction.

***

### userId

> **userId**: `string`

Defined in: common/ChatMessageReaction.ts:16

Operator userId.

## Methods

### fromNative()

> `static` **fromNative**(`params`): `ChatReactionOperation`

Defined in: common/ChatMessageReaction.ts:34

#### Parameters

##### params

###### operate

`number`

###### reaction

`string`

###### userId

`string`

#### Returns

`ChatReactionOperation`
