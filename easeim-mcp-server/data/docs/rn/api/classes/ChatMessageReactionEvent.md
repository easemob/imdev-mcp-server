[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageReactionEvent

# Class: ChatMessageReactionEvent

Defined in: common/ChatMessageReaction.ts:88

The message Reaction event class.

## Constructors

### Constructor

> **new ChatMessageReactionEvent**(`params`): `ChatMessageReactionEvent`

Defined in: common/ChatMessageReaction.ts:105

#### Parameters

##### params

###### convId

`string`

###### msgId

`string`

###### operations

[`ChatReactionOperation`](ChatReactionOperation.md)[]

###### reactions

[`ChatMessageReaction`](ChatMessageReaction.md)[]

#### Returns

`ChatMessageReactionEvent`

## Properties

### convId

> **convId**: `string`

Defined in: common/ChatMessageReaction.ts:92

The conversation ID.

***

### msgId

> **msgId**: `string`

Defined in: common/ChatMessageReaction.ts:96

The message ID.

***

### operations

> **operations**: [`ChatReactionOperation`](ChatReactionOperation.md)[]

Defined in: common/ChatMessageReaction.ts:104

The list of Reaction operations.

***

### reactions

> **reactions**: [`ChatMessageReaction`](ChatMessageReaction.md)[]

Defined in: common/ChatMessageReaction.ts:100

The Reaction list.
