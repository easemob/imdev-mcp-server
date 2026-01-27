[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatError

# Class: ChatError

Defined in: common/ChatError.ts:4

The chat error class, which contains the error code and error description.

## Extended by

- [`ChatException`](ChatException.md)

## Constructors

### Constructor

> **new ChatError**(`params`): `ChatError`

Defined in: common/ChatError.ts:18

#### Parameters

##### params

###### code

`number`

###### description

`string`

#### Returns

`ChatError`

## Properties

### code

> **code**: `number`

Defined in: common/ChatError.ts:12

The error code.

See the error code of the iOS or Android platform:
- iOS: [https://docs.agora.io/en/agora-chat/reference/error-codes?platform=ios](https://docs.agora.io/en/agora-chat/reference/error-codes?platform=ios)
- Android: [https://docs.agora.io/en/agora-chat/reference/error-codes?platform=android](https://docs.agora.io/en/agora-chat/reference/error-codes?platform=android)

***

### description

> **description**: `string`

Defined in: common/ChatError.ts:16

The error description.
