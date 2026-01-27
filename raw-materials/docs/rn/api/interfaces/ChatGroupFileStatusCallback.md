[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupFileStatusCallback

# Interface: ChatGroupFileStatusCallback

Defined in: common/ChatGroup.ts:394

The status change listener for shared files in groups.

## Methods

### onError()

> **onError**(`groupId`, `filePath`, `error`): `void`

Defined in: common/ChatGroup.ts:411

Occurs when there is an error during the upload or download of a shared file.

#### Parameters

##### groupId

`string`

The group ID.

##### filePath

`string`

The path of the shared file.

##### error

[`ChatError`](../classes/ChatError.md)

A description of the error. See [ChatError](../classes/ChatError.md).

#### Returns

`void`

***

### onProgress()?

> `optional` **onProgress**(`groupId`, `filePath`, `progress`): `void`

Defined in: common/ChatGroup.ts:402

Occurs when a shared file is being uploaded or downloaded.

#### Parameters

##### groupId

`string`

The group ID.

##### filePath

`string`

The path of the shared file.

##### progress

`number`

The value of the download or upload progress. The value range is 0-100 in percentage.

#### Returns

`void`

***

### onSuccess()

> **onSuccess**(`groupId`, `filePath`): `void`

Defined in: common/ChatGroup.ts:419

Occurs when the message is sent.

#### Parameters

##### groupId

`string`

The group ID.

##### filePath

`string`

The path of the shared file.

#### Returns

`void`
