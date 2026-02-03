[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatPageResult

# Class: ChatPageResult\<T\>

Defined in: common/ChatPageResult.ts:8

The pagination class.

This class contains the cursor for the next query and the number of records on the page.

The class instance is returned when you make a paginated query.

## Type Parameters

### T

`T`

## Constructors

### Constructor

> **new ChatPageResult**\<`T`\>(`params`): `ChatPageResult`\<`T`\>

Defined in: common/ChatPageResult.ts:19

#### Parameters

##### params

###### list?

`T`[]

###### opt?

\{ `map`: (`obj`) => `any`; \}

###### opt.map

(`obj`) => `any`

###### pageCount

`number`

#### Returns

`ChatPageResult`\<`T`\>

## Properties

### list?

> `optional` **list**: `T`[]

Defined in: common/ChatPageResult.ts:18

The data of the generic List<T> type.

***

### pageCount

> **pageCount**: `number`

Defined in: common/ChatPageResult.ts:14

The number of records on the current page.

If the value of `PageCount` is smaller than the number of records that you expect to get on each page, the current page is the last page.
