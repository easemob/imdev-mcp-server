[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatConversationFetchOptions

# Class: ChatConversationFetchOptions

Defined in: common/ChatConversation.ts:846

The conversation filter class.

## Constructors

### Constructor

> **new ChatConversationFetchOptions**(`params`): `ChatConversationFetchOptions`

Defined in: common/ChatConversation.ts:869

#### Parameters

##### params

###### cursor?

`string`

###### mark?

[`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)

###### pageSize?

`number`

###### pinned?

`boolean`

#### Returns

`ChatConversationFetchOptions`

## Properties

### cursor?

> `optional` **cursor**: `string`

Defined in: common/ChatConversation.ts:856

The cursor to specify where to start retrieving conversations.

***

### mark?

> `optional` **mark**: [`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)

Defined in: common/ChatConversation.ts:868

Whether to get marked conversations.
- `true`: Yes.
- `false`: No.

***

### pageSize?

> `optional` **pageSize**: `number`

Defined in: common/ChatConversation.ts:852

The number of conversations to retrieve.

If you retrieve marked conversations, the value range is [1,10], with 10 as the default. Otherwise, the value range is [1,50].

***

### pinned?

> `optional` **pinned**: `boolean`

Defined in: common/ChatConversation.ts:862

Whether to get pinned conversations.
- `true`: Yes.
- `false`: No.

## Methods

### default()

> `static` **default**(): `ChatConversationFetchOptions`

Defined in: common/ChatConversation.ts:880

#### Returns

`ChatConversationFetchOptions`

***

### pinned()

> `static` **pinned**(): `ChatConversationFetchOptions`

Defined in: common/ChatConversation.ts:886

#### Returns

`ChatConversationFetchOptions`

***

### withMark()

> `static` **withMark**(`mark`): `ChatConversationFetchOptions`

Defined in: common/ChatConversation.ts:892

#### Parameters

##### mark

[`ChatConversationMarkType`](../enumerations/ChatConversationMarkType.md)

#### Returns

`ChatConversationFetchOptions`
