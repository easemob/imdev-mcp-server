[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatException

# Class: ChatException

Defined in: common/ChatError.ts:27

The chat exception class, which contains the code and description.

## Extends

- [`ChatError`](ChatError.md)

## Constructors

### Constructor

> **new ChatException**(`params`): `ChatException`

Defined in: common/ChatError.ts:18

#### Parameters

##### params

###### code

`number`

###### description

`string`

#### Returns

`ChatException`

#### Inherited from

[`ChatError`](ChatError.md).[`constructor`](ChatError.md#constructor)

## Properties

### code

> **code**: `number`

Defined in: common/ChatError.ts:12

The error code.

See the error code of the iOS or Android platform:
- iOS: [https://docs.agora.io/en/agora-chat/reference/error-codes?platform=ios](https://docs.agora.io/en/agora-chat/reference/error-codes?platform=ios)
- Android: [https://docs.agora.io/en/agora-chat/reference/error-codes?platform=android](https://docs.agora.io/en/agora-chat/reference/error-codes?platform=android)

#### Inherited from

[`ChatError`](ChatError.md).[`code`](ChatError.md#code)

***

### description

> **description**: `string`

Defined in: common/ChatError.ts:16

The error description.

#### Inherited from

[`ChatError`](ChatError.md).[`description`](ChatError.md#description)
