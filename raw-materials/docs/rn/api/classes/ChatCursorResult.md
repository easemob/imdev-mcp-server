[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatCursorResult

# Class: ChatCursorResult\<T\>

Defined in: common/ChatCursorResult.ts:6

The generic class which contains the cursor and pagination result.

The class instance is returned when you make a paginated query.

## Type Parameters

### T

`T`

## Constructors

### Constructor

> **new ChatCursorResult**\<`T`\>(`params`): `ChatCursorResult`\<`T`\>

Defined in: common/ChatCursorResult.ts:15

#### Parameters

##### params

###### cursor

`string`

###### list?

`T`[]

###### opt?

\{ `map`: (`obj`) => `any`; \}

###### opt.map

(`obj`) => `any`

#### Returns

`ChatCursorResult`\<`T`\>

## Properties

### cursor

> **cursor**: `string`

Defined in: common/ChatCursorResult.ts:10

The cursor that specifies where to start to get data.

***

### list?

> `optional` **list**: `T`[]

Defined in: common/ChatCursorResult.ts:14

The request result.
