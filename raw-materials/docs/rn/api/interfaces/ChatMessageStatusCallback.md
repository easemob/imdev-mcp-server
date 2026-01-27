[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageStatusCallback

# Interface: ChatMessageStatusCallback

Defined in: common/ChatMessage.ts:319

The message status change listener.

## Methods

### onError()

> **onError**(`localMsgId`, `error`): `void`

Defined in: common/ChatMessage.ts:332

Occurs when a message error occurs.

#### Parameters

##### localMsgId

`string`

##### error

[`ChatError`](../classes/ChatError.md)

A description of the error. See [ChatError](../classes/ChatError.md).

#### Returns

`void`

***

### onProgress()?

> `optional` **onProgress**(`localMsgId`, `progress`): `void`

Defined in: common/ChatMessage.ts:325

Occurs when a message is uploaded or downloaded.

#### Parameters

##### localMsgId

`string`

##### progress

`number`

The message upload/download progress value. The value range is 0 to 100 in percentage.

#### Returns

`void`

***

### onSuccess()

> **onSuccess**(`message`): `void`

Defined in: common/ChatMessage.ts:339

Occurs when a message is successfully delivered.

#### Parameters

##### message

[`ChatMessage`](../classes/ChatMessage.md)

The message that is successfully delivered.

#### Returns

`void`
