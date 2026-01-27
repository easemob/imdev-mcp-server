[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageReaction

# Class: ChatMessageReaction

Defined in: common/ChatMessageReaction.ts:53

The message Reaction instance class that defines Reaction attributes.

## Constructors

### Constructor

> **new ChatMessageReaction**(`params`): `ChatMessageReaction`

Defined in: common/ChatMessageReaction.ts:72

#### Parameters

##### params

###### count

`number`

###### isAddedBySelf

`boolean`

###### reaction

`string`

###### userList

`string`[]

#### Returns

`ChatMessageReaction`

## Properties

### count

> **count**: `number`

Defined in: common/ChatMessageReaction.ts:61

The count of the users who added this Reaction.

***

### isAddedBySelf

> **isAddedBySelf**: `boolean`

Defined in: common/ChatMessageReaction.ts:67

Whether the current user added this Reaction.
- `true`: Yes.
- `false`: No.

***

### reaction

> **reaction**: `string`

Defined in: common/ChatMessageReaction.ts:57

The Reaction content.

***

### userList

> **userList**: `string`[]

Defined in: common/ChatMessageReaction.ts:71

The list of users that added this Reaction.
